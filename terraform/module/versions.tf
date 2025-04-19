terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.36.0"
    }
    kustomization = {
      source  = "kbst/kustomization"
      version = "~> 0.9.0"
    }
  }
# To ensure our team uses a compatible Terraform version
  required_version = ">= 1.4"
}
