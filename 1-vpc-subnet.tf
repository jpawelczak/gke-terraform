
#VPC
resource "google_compute_network" "vpc" {
  name                    = "gke-terraform-vpc"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "gke-terraform-subnet"
  region        = "us-central1"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
  
  #Expose Service defined in app.tf file
  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"
  
}