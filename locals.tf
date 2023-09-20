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
  }]

}
