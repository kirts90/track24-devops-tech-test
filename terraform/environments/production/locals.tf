locals {
  app_kustomize_path = "${path.module}/../../../kustomize/overlays/${var.environment}"
  metrics_server_kustomize_path = "${path.module}/../../../kustomize/metrics-server"
  sealed_secrets_kustomize_path = "${path.module}/../../../kustomize/sealed-secrets"
}
