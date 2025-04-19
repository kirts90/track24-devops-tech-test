module "prod_app" {
  source = "../../module"

  app_kustomize_path            = local.app_kustomize_path
  kube_context                  = var.kube_context
  kubeconfig                    = var.kubeconfig
  metrics_server_kustomize_path = local.metrics_server_kustomize_path
  namespace                     = var.namespace
  sealed_secrets_kustomize_path = local.sealed_secrets_kustomize_path
}
