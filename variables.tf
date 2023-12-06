#######################
## Standard variables
#######################

variable "cluster_name" {
  description = "Name given to the cluster. Value used for naming some the resources created by the module."
  type        = string
}

variable "base_domain" {
  description = "Base domain of the cluster. Value used for the ingress' URL of the application."
  type        = string
}

variable "argocd_namespace" {
  description = "Namespace used by Argo CD where the Application and AppProject resources should be created."
  type        = string
  default     = "argocd"
}

variable "target_revision" {
  description = "Override of target revision of the application chart."
  type        = string
  default     = "v1.0.0" # x-release-please-version
}

variable "cluster_issuer" {
  description = "SSL certificate issuer to use. Usually you would configure this value as `letsencrypt-staging` or `letsencrypt-prod` on your root `*.tf` files."
  type        = string
  default     = "ca-issuer"
}

variable "namespace" {
  description = "Namespace where the applications's Kubernetes resources should be created. Namespace will be created in case it doesn't exist."
  type        = string
  default     = "rclone"
}

variable "helm_values" {
  description = "Helm chart value overrides. They should be passed as a list of HCL structures."
  type        = any
  default     = []
}

variable "app_autosync" {
  description = "Automated sync options for the Argo CD Application resource."
  type = object({
    allow_empty = optional(bool)
    prune       = optional(bool)
    self_heal   = optional(bool)
  })
  default = {
    allow_empty = false
    prune       = true
    self_heal   = true
  }
}

variable "dependency_ids" {
  description = "IDs of the other modules on which this module depends on."
  type        = map(string)
  default     = {}
}

#######################
## Module variables
#######################


variable "oidc" {
  description = "OIDC settings to configure OAuth2-Proxy which will be used to protect Rclone's dashboard."
  type = object({
    issuer_url              = string
    oauth_url               = optional(string, "")
    token_url               = optional(string, "")
    api_url                 = optional(string, "")
    client_id               = string
    client_secret           = string
    oauth2_proxy_extra_args = optional(list(string), [])
  })
  default = null
}

variable "rclone_enable_webui" {
  description = "Boolean to enable the WebUI of Rclone."
  type        = bool
  default     = true
}

variable "rclone_config_file" {
  description = "Configuration of all Rclone backends." # TODO Maybe add a better description of how to configure this variable.
  type        = string
  sensitive   = true
}

variable "enable_grafana_dashboard" {
  description = "Boolean to add a monitoring dashboard to Grafana."
  type        = bool
  default     = false
}

variable "schedules" {
  description = "list of cronjobs to execute"
  type = map(object({
    disabled    = optional(bool, false)
    labels      = optional(map(string), {})
    annotations = optional(map(string), {})
    schedule    = string
    rcloneCmd   = list(string)
  }))
  default = {}
}
