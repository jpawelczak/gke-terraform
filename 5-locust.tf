# AR already created with Locust image

# resource "kubernetes_deployment_v1" "locust" {
#   metadata {
#     name = "locust"
#   }

#   spec {
#     replicas = 1
#     selector {
#       match_labels = {
#         app = "locust"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = "locust"
#         }
#       }
#       spec {
#         container {
#           name = "locust"
#           image = "us-central1-docker.pkg.dev/zeta-post-416508/locust-gke-terraform-repo/locust-tasks"
#           image_pull_policy = "Always"
#           #command = ["locust", "-f", "/locust/simple.py", "--host", "http://fib.${local.fib_svc.metadata[0].namespace}.svc.cluster.local:5000", "--users", "50", "--spawn-rate", "1", "--run-time", "10m"]
#           resources {
#             requests = {
#               cpu = "50m"
#               memory = "128Mi"
#             }
#             limits = {
#               cpu = "2000m"
#               memory = "128Mi"
#             }
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service_v1" "locust" {
#   metadata {
#     name = "locust"
#   }

#   spec {
#     type = "LoadBalancer"
#     external_traffic_policy = "Cluster"
#     selector = {
#       app = "locust"
#     }
#     port {
#       name = "tcp-port"
#       protocol = "TCP"
#       port = 8089
#       target_port = 8089
#     }
#   }
# }
