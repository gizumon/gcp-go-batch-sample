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

## Tech Stacks

### For Job Trigger/Manage

| **Service**                    | **Cloud Scheduler** | **Cloud Tasks** | **Cloud Scheduler + Pub/Sub** |
|--------------------------------|---------------------|----------------|--------------------------------|
| **Time-Based Triggers**        | ✅ Yes              | ❌ No          | ✅ Yes                         |
| **Task Queuing**               | ❌ No               | ✅ Yes         | ❌ No                          |
| **Dynamic Task Creation**      | ❌ No               | ✅ Yes         | ❌ No                          |
| **Event-Driven Workflow**      | ❌ No               | ❌ No          | ✅ Yes                         |
| **Multi-Service Fan-Out**      | ❌ No               | ❌ No          | ✅ Yes                         |
| **Retry Policies**             | ✅ Basic            | ✅ Advanced    | ✅ Yes                         |
| **Workflow Orchestration**     | ❌ No               | ❌ Limited     | ❌ No                          |

### For Job Processing

| **Feature**                    | **Cloud Functions**                       | **Cloud Run Job**                      | **Cloud Batch**                       |
|--------------------------------|-------------------------------------------|----------------------------------------|---------------------------------------|
| **Event-Driven Execution**     | ✅ Yes                                    | ❌ No                                  | ❌ No                                 |
| **Custom Runtime Support**     | ❌ Limited to supported languages         | ✅ Yes (Custom Containers)             | ✅ Yes (Custom VM Environments)       |
| **Automatic Scaling**          | ✅ Yes                                    | ✅ Yes                                 | ❌ No                                 |
| **Long-Running Jobs**          | ❌ No (Max 60mins execution / job)        | ✅ Yes (Max 7days execution / job)     | ✅ Yes (Unlimited?)                   |
| **Job Dependencies**           | ❌ No                                     | ❌ No                                  | ✅ Yes (Job Dependencies)             |
| **Real-Time Requests**         | ✅ Yes                                    | ❌ No                                  | ❌ No                                 |
| **Massive Parallel Processing**| ❌ No                                     | ❌ No                                  | ✅ Yes                                |
| **Resource Limits**            | ❌ Limited (CPU/Memory)                   | ✅ Configurable                        | ✅ Flexible (High Limits)             |
| **Setup Complexity**           | ✅ Low                                    | ❌ Medium (Requires Docker)            | ❌ High (Complex Setup)               |
