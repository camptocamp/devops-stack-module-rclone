locals {
  helm_values = [{
    podLabels = {
        "azure.workload.identity/use" = "true"
      }
    serviceAccount = {
      create = true
      annotations = {
        "azure.workload.identity/client-id" = var.workload_identity_client_id
      }
      name      = "rclone"
      namespace = var.namespace
    }
  }]
}
