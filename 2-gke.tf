
# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "gke-terraform-cluster"
  location = "us-central1"
  
  remove_default_node_pool = true
  initial_node_count = 1

  release_channel {
    channel = "RAPID"
  }

  vertical_pod_autoscaling {
    enabled = true
  }

  #HPA Events logging
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "KCP_HPA"]
  }

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  cluster    = google_container_cluster.primary.name
  
  node_count = 2

  node_config {
#    oauth_scopes = [
#      "https://www.googleapis.com/auth/logging.write",
#      "https://www.googleapis.com/auth/monitoring",
#    ]

    labels = {
      env = "gke-terraform"
    }

    # preemptible  = true
    machine_type = "e2-medium"
    disk_size_gb = 50
    tags         = ["gke-node", "gke-terraform"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}