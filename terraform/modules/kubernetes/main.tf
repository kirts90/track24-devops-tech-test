terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}

locals {
  app_name  = "track24-api"
  namespace = var.namespace
  labels = {
    app = local.app_name
  }
}

# Create namespace if it doesn't exist
resource "kubernetes_namespace" "this" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = local.namespace
  }
}

# Reference existing secret for Google API Key
data "kubernetes_secret" "google_key" {
  metadata {
    name      = "track24-api-secrets"
    namespace = local.namespace
  }
}

# Create GitRepository for Flux CD
resource "kubectl_manifest" "git_repository" {
  count = var.use_kustomize ? 1 : 0

  yaml_body = <<YAML
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: GitRepository
metadata:
  name: ${local.app_name}-gitrepo
  namespace: ${local.namespace}
spec:
  interval: 1m0s
  url: ${var.git_repository_url}
  ref:
    branch: ${var.git_branch}
  timeout: 60s
YAML

  depends_on = [
    kubernetes_namespace.this,
    data.kubernetes_secret.google_key
  ]
}

# Apply kustomization using kubectl provider
resource "kubectl_manifest" "kustomize" {
  count = var.use_kustomize ? 1 : 0

  yaml_body = <<YAML
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: ${local.app_name}
  namespace: ${local.namespace}
spec:
  interval: 1m0s
  path: ${var.kustomize_path}
  prune: true
  targetNamespace: ${local.namespace}
  timeout: 2m0s
  sourceRef:
    kind: GitRepository
    name: ${local.app_name}-gitrepo
    namespace: ${local.namespace}
YAML

  depends_on = [
    kubernetes_namespace.this,
    data.kubernetes_secret.google_key,
    kubectl_manifest.git_repository[0]
  ]
}

# Direct Kubernetes deployment if not using kustomize
resource "kubernetes_deployment" "app" {
  count = var.use_kustomize ? 0 : 1

  metadata {
    name      = local.app_name
    namespace = local.namespace
    labels    = local.labels
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
      }

      spec {
        container {
          name  = "api"
          image = var.image_name

          port {
            container_port = 3000
            name           = "http"
          }

          env {
            name  = "NODE_ENV"
            value = var.environment
          }

          env {
            name  = "APP_PORT"
            value = "3000"
          }

          env {
            name = "GOOGLE_KEY"
            value_from {
              secret_key_ref {
                name = "track24-api-secrets"
                key  = "GOOGLE_API_KEY"
              }
            }
          }

          resources {
            limits = {
              cpu    = var.cpu_limit
              memory = var.memory_limit
            }
            requests = {
              cpu    = var.cpu_request
              memory = var.memory_request
            }
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = "http"
            }
            initial_delay_seconds = 15
            period_seconds        = 20
          }

          readiness_probe {
            http_get {
              path = "/healthz"
              port = "http"
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  count = var.use_kustomize ? 0 : 1

  metadata {
    name      = local.app_name
    namespace = local.namespace
    labels    = local.labels
  }

  spec {
    type = var.service_type

    port {
      port        = 80
      target_port = "http"
      protocol    = "TCP"
      name        = "http"
    }

    selector = local.labels
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "app" {
  count = var.use_kustomize ? 0 : 1

  metadata {
    name      = local.app_name
    namespace = local.namespace
  }

  spec {
    max_replicas = var.max_replicas
    min_replicas = var.min_replicas

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.app[0].metadata[0].name
    }

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 50
        }
      }
    }
  }
}