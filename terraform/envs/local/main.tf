terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

provider "kubectl" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

module "kubernetes" {
  source = "../../modules/kubernetes"

  # Environment specific variables
  namespace        = var.namespace
  create_namespace = var.create_namespace
  environment      = "development"
  image_name       = var.image_name
  google_api_key   = var.google_api_key

  # Resource settings for local environment
  replicas       = 1
  cpu_request    = "50m"
  memory_request = "64Mi"
  cpu_limit      = "200m"
  memory_limit   = "128Mi"
  min_replicas   = 1
  max_replicas   = 3
  service_type   = "NodePort"

  # Kustomize settings
  use_kustomize      = var.use_kustomize
  kustomize_path     = "kustomize/overlays/local"
  git_repository_url = var.git_repository_url
  git_branch         = var.git_branch
}