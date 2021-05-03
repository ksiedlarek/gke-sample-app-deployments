terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
  required_version = "~> 0.15"
  backend "remote" {
    organization = "gcp-demo-ksiedlarek"

    # workspaces {
    #   name = "gke-sample-app-deployments"
    # }
    workspaces {
      name = "gke-sample-app-deployment-cli"
    }
  }

}
