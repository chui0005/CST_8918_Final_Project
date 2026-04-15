resource "kubernetes_namespace_v1" "app" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret_v1" "app" {
  metadata {
    name      = "${var.app_name}-secrets"
    namespace = kubernetes_namespace_v1.app.metadata[0].name
  }

  data = {
    WEATHER_API_KEY = var.weather_api_key
    REDIS_PASSWORD  = var.redis_password
  }
}

resource "kubernetes_deployment_v1" "app" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace_v1.app.metadata[0].name
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          name              = var.app_name
          image             = var.image
          image_pull_policy = "Always"

          port {
            container_port = 3000
          }

          # Secrets (WEATHER_API_KEY, REDIS_PASSWORD) injected from Kubernetes Secret
          env_from {
            secret_ref {
              name = kubernetes_secret_v1.app.metadata[0].name
            }
          }

          env {
            name  = "REDIS_HOST"
            value = var.redis_host
          }

          env {
            name  = "REDIS_PORT"
            value = tostring(var.redis_port)
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 3000
            }
            initial_delay_seconds = 10
            period_seconds        = 5
            failure_threshold     = 3
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 3000
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            failure_threshold     = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "app" {
  metadata {
    name      = "${var.app_name}-svc"
    namespace = kubernetes_namespace_v1.app.metadata[0].name
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}
