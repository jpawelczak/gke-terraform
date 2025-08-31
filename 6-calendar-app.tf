resource "kubernetes_secret" "google_token" {
  metadata {
    name = "google-token"
  }

  data = {
    "token.json" = file("${path.module}/calendar-app/server/token.json")
  }

  type = "Opaque"
}

resource "kubernetes_secret" "google_credentials" {
  metadata {
    name = "google-credentials"
  }

  data = {
    "credentials.json" = file("${path.module}/calendar-app/server/credentials.json")
  }

  type = "Opaque"
}

resource "kubernetes_secret" "gemini_api_key" {
  metadata {
    name = "gemini-api-key"
  }

  data = {
    api_key = "AIzaSyAxr0Iymp-7FwKrckL09wvgd_lfsxE9W5s"
  }

  type = "Opaque"
}

resource "kubernetes_deployment" "calendar_app" {
  metadata {
    name = "calendar-app"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "calendar-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "calendar-app"
        }
      }

      spec {
        container {
          image = "gcr.io/zeta-post-416508/calendar-app:latest"
          name  = "calendar-app"

          port {
            container_port = 8080
          }

          env {
            name = "GEMINI_API_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.gemini_api_key.metadata[0].name
                key  = "api_key"
              }
            }
          }

          volume_mount {
            name       = "google-credentials"
            mount_path = "/app/credentials.json"
            sub_path   = "credentials.json"
          }

          volume_mount {
            name       = "google-token"
            mount_path = "/app/token.json"
            sub_path   = "token.json"
          }
        }

        volume {
          name = "google-credentials"
          secret {
            secret_name = kubernetes_secret.google_credentials.metadata[0].name
          }
        }

        volume {
          name = "google-token"
          secret {
            secret_name = kubernetes_secret.google_token.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "calendar_app" {
  metadata {
    name = "calendar-app"
  }

  spec {
    selector = {
      app = "calendar-app"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}
