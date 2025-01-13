# Pattern1: Cloud Functions pattern

* Cloud Scheduler for cron scheduler
* Cloud Tasks for batch management
* Cloud Functions for batch processing
* Cloud SQL for DB

# How to deploy

```
terraform apply
```

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

