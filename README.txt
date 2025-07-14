# Setting up GKE via terraform

Scope
- terraform
- GKE with k8s 1.33 or newer
- us-east-1 region
- small servers
- standard cluster
-- Rapid channel
-- HPA logs enabled (KCP_HPA)
-- defined node_pool's SSD to remove "quota" blocker ("disk_size_gb = 30")
- deploy simple web app

# HOWTO

Get details about GCP provider from https://registry.terraform.io/providers/hashicorp/google/latest 
Add details to provider.tf file
Initiate terraform (terraform init)

# Observations

## After "terraform apply":
Quota blocks deploying the first cluster = had to find a workaround.
Many services where deployed such Nvidia GPU Plugins or Event Exported Windows.

## After "terraform destroy": 
Got error: "Error: Cannot destroy cluster because deletion_protection is set to true. 
Set it to false to proceed with cluster deletion."