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

# Useful content
GKE startup guide: https://cloud.google.com/kubernetes-engine/docs/quickstarts/create-cluster-using-terraform
GCP Examples: 
- Github: https://github.com/terraform-google-modules/terraform-docs-samples/tree/main/gke/quickstart 
- Tutorials: https://cloud.google.com/docs/terraform 
Terraform.io docs: https://registry.terraform.io/providers/hashicorp/google/latest/docs

# HOWTO

Get details about GCP provider from https://registry.terraform.io/providers/hashicorp/google/latest 
Add details to provider.tf file
Initiate terraform (terraform init)
Add other files and repeate the steps (terraform init -upgrade, etc)

# Observations

## After "terraform apply":
- Quota blocks deploying the first cluster = had to find a workaround.
- Many services where deployed such Nvidia GPU Plugins or Event Exported Windows.

## After successful cluster creation
Connect to cluster via gcloud: gcloud container clusters get-credentials YOURCLUSTERHERE --zone YOURCLUSTERZONEHERE
Check kubectl connection: kubectl get pods -A

# After adding app & service (app.tf)
- After adding app.tf (hello world app), had issues to get the app running - had to add roles and re-certificate the user

## App is running and exposed for few minutes

WORKS! Got bellow message when entered exposed service

`Hello, world!
Version: 2.0.0
Hostname: example-hello-app-deployment-59d49fb958-tvbhx`

## After "terraform destroy": 
- Got error: "Error: Cannot destroy cluster because deletion_protection is set to true. Set it to false to proceed with cluster deletion."
- Initiated cluster deletion via Console UI
- Add "deletion_protection = false" to destroy the cluster via "terraform destroy" command

## Other
- GKE Github examples uses "primary" while GKE Startup Guide uses "default" in resource definition - I had to change it accordingly
- No GKE focused terraform resources in /docs/samples: https://cloud.google.com/docs/samples?language=terraform&product=googlekubernetesengine