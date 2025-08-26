variable "project_id" {
  description = "The project id"
}

variable "tfstate_gcs_backend" {
  description = "Backend bucket to store the terraform state"
}

variable "region" {
  description = "The GCP region to deploy instances into"
  default     = "us-central1"
}

variable "zones" {
  description = "The GCP zone to deploy gke into"
  default     = ["us-central1-a", "us-central1-b"]
}

variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}

variable "ip_range_services_name" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-scv"
}

variable "network_name" {
  description = "Name for the VPC network"
  default     = "test-network"
}
variable "subnet_ip" {
  description = "IP range for the subnet"
  default     = "10.10.10.0/24"
}
variable "subnet_name" {
  description = "Name for the subnet"
  default     = "test-subnet"
}

variable "test_k8s_config" {
  description = "Name for the k8s secret required to configure k8s executers on Jenkins"
  default     = "test-k8s-config"
}

variable "github_repo" {
  description = "Github repo."
  default     = "samrogu/test-devops"
}