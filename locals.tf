locals {
  helm_values = [{
    replicaCount = 1
    image = {
      repository = "rclone/rclone"
      pullPolicy = "IfNotPresent"
      tag        = ""
    }

    service = {
      type = "ClusterIP"
      port = 5572
    }

    ingress = {
      enabled   = true
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
  }]

}
