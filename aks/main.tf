module "rclone" {
  source = "../"

  cluster_name     = var.cluster_name
  base_domain      = var.base_domain
  argocd_namespace = var.argocd_namespace
  target_revision  = var.target_revision
  cluster_issuer   = var.cluster_issuer
  namespace        = var.namespace
  app_autosync     = var.app_autosync
  dependency_ids   = var.dependency_ids

  oidc                            = var.oidc
  rclone_config_file              = var.rclone_config_file
  rclone_enable_webui             = var.rclone_enable_webui
  enable_grafana_dashboard = var.enable_grafana_dashboard

  helm_values = concat(local.helm_values, var.helm_values)
}
