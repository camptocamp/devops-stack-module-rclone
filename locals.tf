locals {
  domain      = format("rclone.apps.%s", var.base_domain)
  domain_full = format("rclone.apps.%s.%s", var.cluster_name, var.base_domain)

  helm_values = [{

    ingress = {
      enabled   = var.rclone_enable_webui
      classname = ""
      annotations = {
        "cert-manager.io/cluster-issuer"                   = "ca-issuer" # TODO: Change to letsencrypt-staging
        "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
        "traefik.ingress.kubernetes.io/router.middlewares" = "traefik-withclustername@kubernetescrd"
        "traefik.ingress.kubernetes.io/router.tls"         = "true"
        "ingress.kubernetes.io/ssl-redirect"               = "true"
        "kubernetes.io/ingress.allow-http"                 = "false"
      }
      hosts = [
        {
          host = local.domain,
          paths = [
            {
              path     = "/"
              pathType = "ImplementationSpecific"
            }
          ]
        },
        {
          host = local.domain_full,
          paths = [
            {
              path     = "/"
              pathType = "ImplementationSpecific"
            }
          ]
        }
      ]
    }
    schedules = var.schedules
    metrics = {
      enabled = true
      serviceMonitor = {
        autodetect       = true
        enabled          = true
        annotations      = {}
        additionalLabels = {}
        prometheusRule = {
          enable           = false
          additionalLabels = {}
          spec             = []
        }
      }
    }

    oidc = var.oidc != null ? {
      oauth2_proxy_image      = "quay.io/oauth2-proxy/oauth2-proxy:v7.4.0"
      issuer_url              = var.oidc.issuer_url
      redirect_url            = format("https://%s/oauth2/callback", local.domain_full)
      client_id               = var.oidc.client_id
      client_secret           = var.oidc.client_secret
      cookie_secret           = resource.random_string.oauth2_cookie_secret.result
      oauth2_proxy_extra_args = var.oidc.oauth2_proxy_extra_args
    } : null

    grafana_dashboard = {
      enabled = true
    }

  }]
}
