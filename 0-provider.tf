# 0-provider means it is the first part of the set up to start

# terraform file with configurstion of provide
# terraform plugin

terraform {

  required_version = ">= 1.0"

  required_providers {

# got it from Registry: https://registry.terraform.io/providers/hashicorp/aws/latest 
    google = {
      source = "hashicorp/google"
      version = "6.43.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "zeta-post-416508"
  
}

   terraform {
    backend "gcs" {
      bucket  = "zeta-post-416508-tfstate"
      prefix  = "terraform/state"
     }
   }
