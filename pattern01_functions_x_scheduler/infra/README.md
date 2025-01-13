# Terraform sample

## How to run

```bash
# from this directory
terraform apply
```

## Initial Setup

* Install Terraform

```bash
brew install tfenv
tfenv list-remote
tfenv use 1.10.4
```

* Create project on GCP

```bash
gcloud projects create gcp-go-batch-sample --name="GCP Go Batch Sample Project"
```

* Enables APIs

```bash
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable cloudscheduler.googleapis.com
```

※ You'll need to enable charging for this project.

## Reference

* Terraform Google Provider: https://registry.terraform.io/providers/hashicorp/google/latest/docs

---

### Trouble shooting


#### Error: Cloud Functions API has not been used in project gcp-go-batch-sample before or it is disabled.

```
Error: googleapi: Error 403: Cloud Functions API has not been used in project gcp-go-batch-sample before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/cloudfunctions.googleapis.com/overview?project=gcp-go-batch-sample then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry.
```
