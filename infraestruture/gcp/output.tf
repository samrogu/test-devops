output "kubernetes_endpoint" {
  description = "The cluster endpoint"
  sensitive   = true
  value       = module.gke.endpoint
}

output "ca_certificate" {
  description = "The cluster ca certificate (base64 encoded)"
  sensitive   = true
  value       = module.gke.ca_certificate
}

output "service_account" {
  description = "The default service account used for running nodes."
  value       = module.gke.service_account
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.gke.name
}

output "k8s_service_account_name" {
  description = "Name of k8s service account."
  value       = module.workload_identity.k8s_service_account_name
}

output "gcp_service_account_email" {
  description = "Email address of GCP service account."
  value       = module.workload_identity.gcp_service_account_email
}

output "jenkins_k8s_config_secrets" {
  description = "Name of the secret required to configure k8s executers on Jenkins"
  value       = var.test_k8s_config
}

output "jenkins_project_id" {
  description = "Project id of Jenkins GKE project"
  value       = module.project-google-apis.project_id
}

output "zone" {
  description = "Zone of Jenkins GKE cluster"
  value       = join(",", var.zones)
}

output "artifact_registry_repository_url" {
  value       = "${google_artifact_registry_repository.docker_repo.location}-docker.pkg.dev/${google_artifact_registry_repository.docker_repo.project}/${google_artifact_registry_repository.docker_repo.repository_id}"
  description = "URL completa del repositorio Docker en Artifact Registry"
}
