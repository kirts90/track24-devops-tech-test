output "namespace" {
  description = "The Kubernetes namespace used"
  value       = local.namespace
}

output "app_name" {
  description = "The application name"
  value       = local.app_name
}

output "deployment_name" {
  description = "The Kubernetes deployment name"
  value       = var.use_kustomize ? null : kubernetes_deployment.app[0].metadata[0].name
}

output "service_name" {
  description = "The Kubernetes service name"
  value       = var.use_kustomize ? null : kubernetes_service.app[0].metadata[0].name
}

output "secret_name" {
  description = "The Kubernetes secret name"
  value       = "track24-api-secrets"
}