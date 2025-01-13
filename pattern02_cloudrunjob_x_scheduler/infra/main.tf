# Main module for cloud infrastructure

# Create a Cloud SQL instance
resource "google_sql_database_instance" "cloud_sql_instance" {
  name             = var.cloud_sql_instance_name
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro" # Smallest instance tier
  }
  lifecycle {
    prevent_destroy = false # set to "true" in production
  }
  deletion_protection = false # set to "true" in production
}

# Create a database inside the Cloud SQL instance
resource "google_sql_database" "default_db" {
  name     = "default_db"
  instance = google_sql_database_instance.cloud_sql_instance.name
}

# Create a Cloud SQL user
resource "google_sql_user" "cloud_sql_user" {
  name     = var.cloud_sql_user
  instance = google_sql_database_instance.cloud_sql_instance.name
  password = var.cloud_sql_password
}

# Create a Cloud Run (v2) job
resource "google_cloud_run_v2_job" "sample_job" {
  name     = "sample-job"
  location = "us-central1"

  deletion_protection = false # set to "true" in production
  template {
    task_count  = 3
    parallelism = 3

    template {
      timeout     = "3600s" # max 7days
      max_retries = 3
      containers {
        image = "gcr.io/${var.project_id}/${var.image}:latest"
        args = [
          "--name=default",
        ]
      }
    }
  }
}

resource "google_cloud_scheduler_job" "sample-job_01" {
  name        = "sample-job-01"
  description = "Run cloud Run job Every 5 mins"
  schedule    = "*/5 * * * *" # Every 5 mins
  time_zone   = "Asia/Tokyo"  # Adjust as needed, e.g., "Asia/Tokyo" for JST

  retry_config {
    # Retries will occur up to 3 times with an initial 10s delay, doubling twice up to a maximum of 1 hour between attempts.
    # e.g) 1st: 10sec after failure, 2nd: 20sec after the 1st retry, 3rd: 40sec after the 2nd retry
    min_backoff_duration = "10s"
    max_backoff_duration = "3600s"
    max_doublings        = 2
    retry_count          = 3
  }
  http_target {
    http_method = "POST"
    uri         = "https://${google_cloud_run_v2_job.sample_job.location}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_id}/jobs/${google_cloud_run_v2_job.sample_job.name}:run"

    oidc_token {
      service_account_email = google_service_account.scheduler_service_account.email
    }

    body = base64encode(
      jsonencode({
        "args" = [
          "--name=sample-success",                                                       # Fixed value
          "--from-date=${formatdate("YYYY-MM-DD hh:mm:ss", timestamp())}",               # Current datetime
          "--to-date=${formatdate("YYYY-MM-DD hh:mm:ss", timeadd(timestamp(), "12h"))}", # 7 days later
        ]
      })
    )
  }
}

resource "google_cloud_scheduler_job" "sample-job_02" {
  name        = "sample-job-02"
  description = "Run cloud Run job Every 10 mins"
  schedule    = "*/10 * * * *" # Every 10 mins
  time_zone   = "Asia/Tokyo"   # Adjust as needed, e.g., "Asia/Tokyo" for JST

  retry_config {
    # Retries will occur up to 3 times with an initial 10s delay, doubling twice up to a maximum of 1 hour between attempts.
    # e.g) 1st: 10sec after failure, 2nd: 20sec after the 1st retry, 3rd: 40sec after the 2nd retry
    min_backoff_duration = "10s"
    max_backoff_duration = "3600s"
    max_doublings        = 2
    retry_count          = 3
  }
  http_target {
    http_method = "POST"
    uri         = "https://${google_cloud_run_v2_job.sample_job.location}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_id}/jobs/${google_cloud_run_v2_job.sample_job.name}:run"

    oidc_token {
      service_account_email = google_service_account.scheduler_service_account.email
    }

    body = base64encode(
      jsonencode({
        "args" = [
          "--name=sample-fail",                                                           # Fixed value
          "--from-date=${formatdate("YYYY-MM-DD hh:mm:ss", timestamp())}",                # Current datetime
          "--to-date=${formatdate("YYYY-MM-DD hh:mm:ss", timeadd(timestamp(), "168h"))}", # 7 days later
        ]
      })
    )
  }

  # Use an explicit depends_on clause to wait until API is enabled
  depends_on = [
    # resource.google_project_service.cloudscheduler_api,
    resource.google_cloud_run_v2_job.sample_job,
    # resource.google_cloud_run_v2_job_iam_binding.binding,
  ]
}

# Service Account for Scheduler
resource "google_service_account" "scheduler_service_account" {
  account_id   = "scheduler-service-account"
  display_name = "Scheduler Service Account"
}
resource "google_project_iam_binding" "scheduler_cloud_run_invoker" {
  project = var.project_id

  role = "roles/run.invoker"

  members = [
    "serviceAccount:${google_service_account.scheduler_service_account.email}"
  ]
}
