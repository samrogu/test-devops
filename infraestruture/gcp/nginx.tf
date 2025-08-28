resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  create_namespace = true

  values = [yamlencode({
    controller = {
      service = {
        type = "LoadBalancer"
        annotations = {
          "cloud.google.com/load-balancer-type" = "External"
        }
      }
    }
  })]
}

resource "kubernetes_ingress_v1" "catch_all_redirect" {
  metadata {
    name      = "catch-all-redirect"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class"                         = "nginx"
      "nginx.ingress.kubernetes.io/permanent-redirect"      = "https://sagurodev.com"
      "nginx.ingress.kubernetes.io/permanent-redirect-code" = "308"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "hecho"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [ helm_release.nginx_ingress ]
}
