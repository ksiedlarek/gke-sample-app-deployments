data "terraform_remote_state" "gke" {
  backend = "remote"
  config = {
    organization = "gcp-demo-ksiedlarek"
    workspaces = {
      name = "gke-base-infra"
    }
  }
}

data "google_client_config" "default" {}

data "google_container_cluster" "my_cluster" {
  name     = data.terraform_remote_state.gke.outputs.kubernetes_cluster_name
  location = "europe-central2-a"
}
