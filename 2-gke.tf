
# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "gke-terraform-cluster"
  location = var.gke_region
  
  remove_default_node_pool = true
  initial_node_count = 1

  release_channel {
    channel = "RAPID"
  }

  cluster_autoscaling {
    enabled = true
    autoscaling_profile = "OPTIMIZE_UTILIZATION"
    resource_limits {
      resource_type = "cpu"
      minimum = 4
      maximum = 100
    }
    resource_limits {
      resource_type = "memory"
      minimum = 16
      maximum = 400
    }
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

  deletion_protection = false
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  cluster    = google_container_cluster.primary.name

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  management {
    auto_upgrade = true
    auto_repair = true
  }

  node_config {
#    oauth_scopes = [
#      "https://www.googleapis.com/auth/logging.write",
#      "https://www.googleapis.com/auth/monitoring",
#    ]

    labels = {
      env = "gke-terraform"
    }

    preemptible  = false
    machine_type = "e2-standard-4"
    disk_size_gb = 50
    tags         = ["gke-node", "gke-terraform"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}