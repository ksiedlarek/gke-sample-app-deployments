
resource "kubernetes_namespace" "hello_app" {
  metadata {
    annotations = {
      name = var.app_name
    }

    labels = {
      app = var.app_name
    }

    name = var.app_name
  }
  timeouts {
    delete = 0
  }
}

resource "kubernetes_deployment" "hello_app" {
    metadata {
    name = var.app_name
    namespace = kubernetes_namespace.hello_app.metadata[0].name
    labels = {
      app = var.app_name
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = var.app_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }
      spec {
        container {
          image = "gcr.io/${var.project_id}/${var.app_name}:${var.tag}"
          name  = var.app_name

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
    name      = var.app_name
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
