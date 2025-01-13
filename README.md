# ToDo

* [x] Try Cloud functions
  * [x] How to run code in LOCAL env
  * [ ] How to write Tests
    * [ ] How to write Mocks
  * [x] How to deploy (scheduler / functions / db)

* [ ] Try Cloud Run job
  * [ ] How to run code in LOCAL env
  * [ ] How to write Tests
    * [ ] How to write Mocks
  * [ ] How to deploy (scheduler / Run job / db)

---

# GCP Batch sample in Golang

This repository is for making sure the system architecture of batch project in GCP.

* Pattern1: Cloud functions x Cloud Scheduler
  * Cloud Scheduler for cron scheduler
  * Cloud Functions for batch processing
  * Cloud SQL for DB
  * Cloud Storage for deployment
* Pattern2: Cloud Run job x Cloud Scheduler
  * Cloud Scheduler for cron scheduler
  * Cloud Run job for batch processing
  * Cloud SQL for DB
  * Cloud Storage for deployment

## Local Environment for functions

```bash
LOCAL_ONLY=true FUNCTION_TARGET=success go run cmd/main.go
```

```bash
curl http://localhost:8080
```

## Reference

* Code sample:
  * https://github.com/GoogleCloudPlatform/golang-samples/tree/main/functions/functionsv2/helloworld
* Local env sample:
  * https://github.com/GoogleCloudPlatform/functions-framework-go?tab=readme-ov-file#quickstart-hello-world-on-your-local-machine

