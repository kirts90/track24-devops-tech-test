resource "kubernetes_namespace" "app" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
  }
}

data "kustomization_build" "app" {
  path = var.app_kustomize_path
}

resource "kustomization_resource" "app" {
  for_each = data.kustomization_build.app.ids

  manifest = data.kustomization_build.app.manifests[each.value]

  depends_on = [kubernetes_namespace.app, kustomization_resource.sealed_secrets]
}

# Metrics server (conditionally apply)
data "kustomization_build" "metrics_server" {
  count = var.enable_metrics_server ? 1 : 0
  path  = var.metrics_server_kustomize_path
}

resource "kustomization_resource" "metrics_server" {
  for_each = var.enable_metrics_server ? data.kustomization_build.metrics_server[0].ids : toset([])

  manifest = data.kustomization_build.metrics_server[0].manifests[each.value]
}
# Metrics server add-on enable for minikube
resource "null_resource" "enable_metrics_server_addon" {
  count = var.enable_metrics_server && var.kube_context == "minikube" ? 1 : 0

  provisioner "local-exec" {
    command = "minikube addons enable metrics-server"
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [kustomization_resource.metrics_server]
}

# Sealed secrets
data "kustomization_build" "sealed_secrets" {
  path = var.sealed_secrets_kustomize_path
}

resource "kustomization_resource" "sealed_secrets" {
  for_each = data.kustomization_build.sealed_secrets.ids

  manifest = data.kustomization_build.sealed_secrets.manifests[each.value]

}
