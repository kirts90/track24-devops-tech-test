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

variable "google_api_key" {
  description = "Google API key for geocoding service (not required if using existing secret)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "environment" {
  description = "Environment (development, production)"
  type        = string
  default     = "production"
}

variable "image_name" {
  description = "Container image name with tag"
  type        = string
}

variable "replicas" {
  description = "Number of replicas for the deployment"
  type        = number
  default     = 2
}

variable "cpu_request" {
  description = "CPU request for each pod"
  type        = string
  default     = "100m"
}

variable "memory_request" {
  description = "Memory request for each pod"
  type        = string
  default     = "128Mi"
}

variable "cpu_limit" {
  description = "CPU limit for each pod"
  type        = string
  default     = "500m"
}

variable "memory_limit" {
  description = "Memory limit for each pod"
  type        = string
  default     = "256Mi"
}

variable "min_replicas" {
  description = "Minimum number of replicas for HPA"
  type        = number
  default     = 2
}

variable "max_replicas" {
  description = "Maximum number of replicas for HPA"
  type        = number
  default     = 5
}

variable "service_type" {
  description = "Kubernetes service type (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "ClusterIP"
}

variable "use_kustomize" {
  description = "Whether to use Kustomize for deployment"
  type        = bool
  default     = true
}

variable "kustomize_path" {
  description = "Path to the Kustomize overlay"
  type        = string
  default     = "./kustomize/overlays/production"
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