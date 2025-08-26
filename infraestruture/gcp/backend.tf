terraform {
  backend "gcs" {
    bucket = "testdevops1"
    prefix = "test-devops/terraform/state"
  }
}