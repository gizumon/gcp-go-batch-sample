# ToDo

* [ ] Try Cloud functions in local
  * [x] How to run Cloud functions in LOCAL
  * [ ] How to write Tests
    * [ ] How to write Mocks
* [ ] Try scheduler (Cloud Scheduler / Cloud Tasks)
* [ ] Try IaC by Terraform

---

# GCP Batch sample in Golang

This repository is for making sure the system architecture of batch project in GCP.

* Cloud Scheduler for cron scheduler
* Cloud Tasks for batch management
* Cloud Functions for batch processing
* Cloud SQL for DB

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

