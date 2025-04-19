

variable "app_kustomize_path" {
  description = "(Required) Filesystem path to the Kustomize overlay for the application."
  type        = string
}

variable "create_namespace" {
  description = "(Optional) Whether to create the Kubernetes namespace."
  type        = bool
  default     = true
}

variable "enable_metrics_server" {
  description = "(Optional) Enable deployment of metrics-server resources."
  type        = bool
  default     = true
  
}

variable "kube_context" {
  description = "(Required) The name of the Kubernetes context to use."
  type        = string
}

variable "kubeconfig" {
  description = "(Optional) Path to the kubeconfig file."
  type        = string
  default     = "~/.kube/config"
}

variable "metrics_server_kustomize_path" {
  description = "(Optional) Filesystem path to the Kustomize overlay for metrics-server."
  type        = string
}
variable "namespace" {
  description = "(Required) Namespace to deploy the application into."
  type        = string
}

variable "sealed_secrets_kustomize_path" {
  description = "(Optional) Filesystem path to the Kustomize overlay for sealed-secrets."
  type        = string
}