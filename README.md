# Purpose

Purpose of this repository is to show how automatic build and deployment can be done and verified in GCP environment.

Sample application is taken from offical Google resources:
https://github.com/GoogleCloudPlatform/kubernetes-engine-samples

Before running it, you need to have GCP project with GKE cluster. Additional steps are required on repository level to make it work with GitHub Actions and Terraform.

This infrastructure is only a demo, it does not contain production-ready environment.



# Workflow status
[![.github/workflows/build-deploy-hello-app-image.yml](https://github.com/ksiedlarek/gke-sample-app-deployments/actions/workflows/build-deploy-hello-app-image.yml/badge.svg?branch=gke-terraform-deploy)](https://github.com/ksiedlarek/gke-sample-app-deployments/actions/workflows/build-deploy-hello-app-image.yml)

[![.github/workflows/build-hello-app-image.yml](https://github.com/ksiedlarek/gke-sample-app-deployments/actions/workflows/build-hello-app-image.yml/badge.svg)](https://github.com/ksiedlarek/gke-sample-app-deployments/actions/workflows/build-hello-app-image.yml)
