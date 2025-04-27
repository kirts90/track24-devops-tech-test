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
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # These values should be provided via -backend-config or CLI
    # bucket = "terraform-state"
    # key    = "track24-api/production/terraform.tfstate"
    # region = "eu-west-2"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
    }
  }
}

# AWS EKS cluster authentication
data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

# Get ECR repository URL to use as image source
data "aws_ecr_repository" "api" {
  name = var.ecr_repository_name
}

locals {
  image_name = "${data.aws_ecr_repository.api.repository_url}:${var.image_tag}"
}

module "kubernetes" {
  source = "../../modules/kubernetes"

  # Environment specific variables
  namespace        = var.namespace
  create_namespace = var.create_namespace
  environment      = "production"
  image_name       = local.image_name
  google_api_key   = var.google_api_key

  # Resource settings for production environment
  replicas       = 3
  cpu_request    = "200m"
  memory_request = "256Mi"
  cpu_limit      = "1000m"
  memory_limit   = "512Mi"
  min_replicas   = 3
  max_replicas   = 10
  service_type   = "LoadBalancer"

  # Kustomize settings
  use_kustomize      = var.use_kustomize
  kustomize_path     = "kustomize/overlays/production"
  git_repository_url = var.git_repository_url
  git_branch         = var.git_branch
}