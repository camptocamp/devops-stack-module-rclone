terraform {
  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = ">= 5"
    }
    utils = {
      source  = "cloudposse/utils"
      version = ">= 1"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes" # Needed for the creation of a Kubernetes secret
      version = ">= 2"
    }

  }
}
