variable "project_id" {
  description = "GCP project id"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default = "europe-central2"
}

variable "zone" {
  description = "GCP zone"
  default = "europe-central2-a"
}

variable "tag" {
  description = "Current application tag"
  type = string
  default = "v1"
}

variable "app_name" {
  description = "Application name"
  type = string
  default = "hello-app"
}

variable "gke_cluster_name" {
  description = "GKE cluster name"
  type = string
}
