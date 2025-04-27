variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace to deploy resources"
  type        = string
  default     = "track24-api"
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = true
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "track24-api"
}

variable "image_tag" {
  description = "Image tag to deploy"
  type        = string
  default     = "latest"
}

variable "google_api_key" {
  description = "Google API key for geocoding service (not required if using existing secret)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "use_kustomize" {
  description = "Whether to use Kustomize for deployment"
  type        = bool
  default     = true
}

variable "git_repository_url" {
  description = "Git repository URL containing Kustomize files"
  type        = string
}

variable "git_branch" {
  description = "Git branch to use"
  type        = string
  default     = "main"
}