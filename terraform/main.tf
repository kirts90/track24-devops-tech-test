resource "kubernetes_manifest" "app" {
  for_each = fileset(local.kustomization_path, "*.yaml")

  manifest = yamldecode(file("${local.kustomization_path}/${each.value}"))
}