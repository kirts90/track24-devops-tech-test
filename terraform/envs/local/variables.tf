variable "namespace" {
  description = "Kubernetes namespace to deploy resources"
  type        = string
  default     = "default"
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = false
}

variable "image_name" {
  description = "Container image name with tag"
  type        = string
  default     = "my-api:dev"
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
  default     = "https://github.com/kirts90/track24-devops-tech-test"
}

variable "git_branch" {
  description = "Git branch to use"
  type        = string
  default     = "main"
}