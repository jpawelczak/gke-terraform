
resource "google_compute_network" "vpc_network" {
  project                 = "zeta-post-416508" # Replace this with your project ID in quotes
  name                    = "gke-terraform-demo"
  auto_create_subnetworks = true
  mtu                     = 1460
}
