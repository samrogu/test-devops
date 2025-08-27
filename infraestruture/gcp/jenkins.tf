

module "workload_identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version             = "38.0.1"
  project_id          = module.project-google-apis.project_id
  name                = "jenkins-wi-${module.gke.name}"
  namespace           = "default"
  use_existing_k8s_sa = false
}

# enable GSA to add and delete pods for jenkins builders
resource "google_project_iam_member" "cluster" {
  project = module.project-google-apis.project_id
  role    = "roles/container.developer"
  member  = module.workload_identity.gcp_service_account_fqn
}


resource "kubernetes_secret" "jenkins-secrets" {
  metadata {
    name = var.test_k8s_config
  }
  data = {
    project_id          = module.project-google-apis.project_id
    kubernetes_endpoint = "https://${module.gke.endpoint}"
    ca_certificate      = module.gke.ca_certificate
    jenkins_tf_ksa      = module.workload_identity.k8s_service_account_name
  }
}


data "local_file" "helm_chart_values" {
  filename = "${path.module}/jenkins-values.yaml"
}


resource "helm_release" "jenkins" {
  name       = "jenkinsci"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "5.8.83"
  timeout    = 1200

  values = [data.local_file.helm_chart_values.content]

}