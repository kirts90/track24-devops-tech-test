
variable "environment" {
  description = "(Required) Deployment environment (e.g., local, dev, staging, production). Used to select the correct Kustomize overlay."
  type        = string
  default     = "production"
}

variable "kubeconfig" {
  description = "(Required) Path to the kubeconfig file. This file is used for authenticating and configuring access to the Kubernetes cluster."
  type        = string
}

variable "kube_context" {
  description = "(Required) The name of the Kubernetes context to use within the provided kubeconfig file."
  type        = string
}

variable "namespace" {
  description = "(Required) Kubernetes namespace to deploy the application into. This can be overridden based on the environment."
  type        = string
  default     = "arun-lab-test"
}
