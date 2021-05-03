output "bucket_uri" {
  value       = google_container_registry.registry.bucket_self_link
  description = "URI of created bucket"
}

output "lb_ip" {
  value = kubernetes_service.hello_app.status.0.load_balancer.0.ingress.0.ip
}
