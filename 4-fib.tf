
# resource "kubernetes_deployment_v1" "fib" {
#   metadata {
#     name      = "fib"
#   }
#   spec {
#     replicas = 1
#     selector {
#       match_labels = {
#         app = "fib"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = "fib"
#         }
#       }
#       spec {
#         container {
#           name              = "fib"
#           image             = "us-central1-docker.pkg.dev/zeta-post-416508/fib:latest"
#           #image_pull_policy = "Always"
#           resources {
#             requests = {
#               cpu    = "1000m"
#               memory = "128Mi"
#             }
#             limits = {
#               cpu    = "2000m"
#               memory = "128Mi"
#             }
#           }
#           port {
#             container_port = 5000
#             name           = "web"
#             protocol       = "TCP"
#           }
#         }
#         node_selector = var.node_selector
#       }
#     }
#   }
# }

# resource "kubernetes_horizontal_pod_autoscaler_v2" "fib" {
#   metadata {
#     name      = "fib"
#   }
#   spec {
#     min_replicas = 2
#     max_replicas = 50
#     scale_target_ref {
#       api_version = "apps/v1"
#       kind        = "Deployment"
#       name        = "fib"
#     }
#     metric {
#       type = "Resource"
#       resource {
#         name = "cpu"
#         target {
#           type                = "Utilization"
#           average_utilization = "70"
#         }
#       }
#     }
#     behavior {
#       scale_down {
#         stabilization_window_seconds = 60
#         policy {
#           period_seconds = 15
#           type           = "Percent"
#           value          = 100
#         }
#         select_policy = "Min"
#       }
#       scale_up {
#         stabilization_window_seconds = 0
#         policy {
#           period_seconds = 15
#           type           = "Percent"
#           value          = 100
#         }
#         policy {
#           period_seconds = 15
#           type           = "Pods"
#           value          = 1000
#         }
#         select_policy = "Max"
#       }
#     }
#   }
# }

# resource "kubernetes_service_v1" "fib" {
#   metadata {
#     name      = "fib"
#   }
#   spec {
#     type                    = "LoadBalancer"
#     external_traffic_policy = "Cluster"
#     selector = {
#       app = "fib"
#     }
#     port {
#       name        = "tcp-port"
#       protocol    = "TCP"
#       port        = 5000
#       target_port = 5000
#     }
#   }
# }
