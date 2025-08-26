terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.49.2"
    }
    helm = {
      source = "hashicorp/helm"
      version = "3.0.2"
    }
  }
}
provider "google" {
  # Configuration options
  region = var.region
  project = var.project_id
}

provider "helm" {
  kubernetes = {
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.default.access_token
  }
}