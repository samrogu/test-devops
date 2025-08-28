# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-public-cluster"
  version = "38.0.1"
  project_id                 = module.project-google-apis.project_id
  name                       = "gke-test-1"
  region                     = var.region
  zones                      = var.zones
  network                    = module.test-devops-vpc.network_name
  subnetwork                 = module.test-devops-vpc.subnets_names[0]
  ip_range_pods              = var.ip_range_pods_name
  ip_range_services          = var.ip_range_services_name
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  dns_cache                  = false
  deletion_protection        = false
  http_load_balancing        = true
  service_account            = "create"
  identity_namespace         = "${module.project-google-apis.project_id}.svc.id.goog"
  depends_on = [
    module.project-google-apis
  ]
}

resource "google_project_iam_member" "artifact_registry_access" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${module.gke.service_account}"
}

resource "google_artifact_registry_repository" "docker_repo" {
  provider     = google
  location     = var.region
  repository_id = "test-devops-repo"
  description  = "Repositorio Docker para el proyecto DevOps Java"
  format       = "DOCKER"
  labels = {
    environment = "dev"
    team        = "devops"
  }
}

resource "google_artifact_registry_repository_iam_member" "member" {
  project = google_artifact_registry_repository.docker_repo.project
  location = google_artifact_registry_repository.docker_repo.location
  repository = google_artifact_registry_repository.docker_repo.name
  role = "roles/artifactregistry.reader"
  member = module.workload_identity.gcp_service_account_fqn
}


