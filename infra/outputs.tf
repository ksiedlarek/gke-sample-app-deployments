output "bucket_uri" {
    value = google_container_registry.registry.bucket_self_link
    description = "URI of created bucket"
}
