# GKE - Sample app deployment

## Purpose
The purpose of this repository is to show how automatic build and deployment of sample application can be done in GCP environment, using GitHub Actions and Terraform Cloud.

## Diagram

![Diagram](/docs/img/deployment_1.svg "Diagram" =200x100)

## Setup

Sample application is taken from offical Google resources:
https://github.com/GoogleCloudPlatform/kubernetes-engine-samples.

We are using [hello-app](https://github.com/GoogleCloudPlatform/kubernetes-engine-samples/tree/master/hello-app) written in Golang.

Terraform Cloud integration was set up based on official HashiCorp [tutorials](https://learn.hashicorp.com/tutorials/terraform/github-actions) and documentation.

This repository has two branches - each shows different way of deployment to GKE:
- main branch: deployment without terraform, using kubectl (work in progress)
- gke-terraform-deploy branch: deployment using only terraform

Hence, there are two pipelines, each triggered from different branch.

Before running this code, you need to have:
- GCP project with admin rights
- Terraform Cloud organisation
- GKE cluster, GCR (you can use code from [gke-base-infra](https://github.com/ksiedlarek/gke-base-infra))
- GCP Service Account credentials
- GCP Bucket

Additional steps are required on repository level to make it work with GitHub Actions and Terraform.

To be able to replicate [terraform pipeline](https://github.com/ksiedlarek/gke-sample-app-deployments/tree/gke-terraform-deploy):

1. Fork this repository (or clone and setup on GitHub)
2. Create your own namespace within your [Terraform Cloud organisation](https://app.terraform.io/):
    - Select [CLI-driven workflow](https://www.terraform.io/docs/cloud/run/cli.html)
    - [Execution mode](https://www.terraform.io/docs/cloud/workspaces/settings.html): Remote
    - Apply method: Manual Apply
    - Set Namespace [variables](https://www.terraform.io/docs/cloud/workspaces/variables.html): 
        - project_id (your project id)
        - region (region that should be the same as one used by your GKE cluster)
    - Set Namespace Environment Variables:
        - GOOGLE_CREDENTIALS (check: sensitive, paste here your GCP service account json credentials, you have to remove blank lines from that file or it won't work)
    - In your account profile, go to [User Settings -> Tokens](https://www.terraform.io/docs/cloud/users-teams-organizations/users.html). Create token that will be used by GitHub Actions. Save the value for later use.
2. Navigate to terraform directory (infra/):
    - change backend configuration in config/dev/backend.tfvars (organization name and workspace name)
3. Navigate to .github/workflows/, open build-deploy-hello-app-image.yml:
    - Set environment variables to match your setup:
        - PROJECT_ID (your GCP project id)
        - PROJECT_NAME (project name - this is used for logs)
4. On repository level, go to Settings:
    - On Secrets tab, [create following secrets](https://docs.github.com/en/actions/reference/encrypted-secrets):
        - GCLOUD_SERVICE_KEY -> base64 encoded json file content (your GCP service account credentials)
        - TF_API_TOKEN -> token that you copied from Terraform Cloud
        - REPO_ACCESS_TOKEN -> on your GitHub account level/organisation level, [create access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) that can read repository information and trigger workflows - paste it here. This is needed for automatic trigger of validation pipeline. (if you don't want to do that, you can skip it)
    - On Environments tab:
        - Create new environment, with name "dev"
        - On environment protection rules click on checkbox "Required reviewers" and add yourself
        - Add gke-terraform-deploy branch to Branch protection rules
5. Fork (or clone and set up on GitHub) [validation repo](https://github.com/ksiedlarek/gcp-deployment-validation)
6. On validation repo:
    - Go to Repository Settings tab -> Secrets, and add:
        - GCP_CREDENTIALS -> base64 encoded json file content (your GCP service account credentials)
        - GH_TOKEN -> on your GitHub account level/organisation level, create access token that can read repository information and trigger workflows - paste it here. This is needed to query logs from other repositories. (if you don't want to do that, you can skip it)
    - Navigate to .github/workflows/triggered-workflow.yml:
        - change BUCKET_NAME to GCP bucket that exists on your GCP project - here all of the logs will be stored
7. Terraform branch of gke-sample-app-deployments triggers on push. You can update any file (for example [version.txt](https://github.com/ksiedlarek/gke-sample-app-deployments/blob/gke-terraform-deploy/apps/hello-app/version.txt)) and push your changes.
8. If everything was set up correctly, you should see your pipeline under Actions tab:
    - you will have to manually approve deployment
    - terraform will output IP address that you can hit to see if app was deployed successfully
    - Repository Dispatch step (at the very end) will trigger pipeline in validation repo - if you don't need it, feel free to comment it out
9. If you are using validation repo, after successful finish of app deployment, you can navigate to Actions tab in there. You should see workflow run that does following steps:
    - Displays payload
    - Tests if IP address provided from deployment returns 200 HTTP code (with curl)
    - Gets logs from deployment pipeline and stores them on GCP bucket


**This infrastructure is only a demo, it does not contain production-ready environment.**
