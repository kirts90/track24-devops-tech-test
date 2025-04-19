
terraform {
  required_providers {
    kustomization = {
      source  = "kbst/kustomization"
      version = "~> 0.9"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"  # Optional: Consider updating to the latest version
    }
  }
}

provider "kustomization" {
  kubeconfig_path = var.kubeconfig
  context         = var.kube_context
}

provider "kubernetes" {
  config_path    = var.kubeconfig
  config_context = var.kube_context
}

# Backend configuration need before going to prod (s3 with state lock )