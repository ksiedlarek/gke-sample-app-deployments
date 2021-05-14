provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  #load_config_file = "false"
  #host                   = data.terraform_remote_state.gke.outputs.kubernetes_cluster_host
  host                   = data.google_container_cluster.my_cluster.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
}

