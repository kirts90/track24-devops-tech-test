provider "kubernetes" {
  config_path    = var.kubeconfig
  config_context = var.kube_context
}