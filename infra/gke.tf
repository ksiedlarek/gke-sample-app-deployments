
resource "kubernetes_namespace" "hello_app" {
  metadata {
    annotations = {
      name = "hello-app"
    }

    labels = {
      app = "hello-app"
    }

    name = "hello-app"
  }
  timeouts {
    delete = 0
  }
}

resource "kubernetes_deployment" "hello_app" {
    metadata {
    name = "hello-app"
    namespace = kubernetes_namespace.hello_app.metadata[0].name
    labels = {
      app = "hello-app"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "hello-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "hello-app"
        }
      }
      spec {
        container {
          image = "gcr.io/${var.project_id}/hello-app:${var.tag}"
          name  = "hello-app"

          port {
            container_port = 8080
          }
          resources {
            requests = {
              cpu    = "250m"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hello_app" {
  metadata {
    name = "hello-app"
    namespace = kubernetes_namespace.hello_app.metadata[0].name
  }
  spec {
    selector = {
      app = kubernetes_deployment.hello_app.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}
