resource "kubernetes_namespace" "development" {
  metadata {
    annotations = {
      name = "development"
    }

    labels = {
      app = "development"
    }

    name = "development"
  }
}


resource "kubernetes_namespace" "production" {
  metadata {
    annotations = {
      name = "production"
    }
    labels = {
      app = "production"
    }
    name = "production"
  }
}