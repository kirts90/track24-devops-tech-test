variable "environment" {
  description = "Deployment environment (local or production)"
  type        = string
  default     = "local"
}

variable "kubeconfig" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Kubeconfig context"
  type        = string
  default     = ""
}