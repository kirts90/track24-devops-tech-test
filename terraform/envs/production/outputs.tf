output "namespace" {
  description = "The Kubernetes namespace"
  value       = module.kubernetes.namespace
}

output "app_name" {
  description = "The application name"
  value       = module.kubernetes.app_name
}

output "deployment_name" {
  description = "The Kubernetes deployment name"
  value       = module.kubernetes.deployment_name
}

output "service_name" {
  description = "The Kubernetes service name"
  value       = module.kubernetes.service_name
}

output "image_name" {
  description = "The full image name used for deployment"
  value       = local.image_name
}