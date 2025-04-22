locals {
  overlay = var.environment == "production" ? "production" : "local"
  kustomization_path = "${path.module}/kustomize/overlays/${local.overlay}"
}