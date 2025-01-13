# Main module for cloud infrastructure

# Create a Cloud SQL instance
resource "google_sql_database_instance" "cloud_sql_instance" {
  name             = var.cloud_sql_instance_name
  database_version = "MYSQL_8_0"
  region           = var.region

  deletion_protection = false # Should not be false in the actual production
  settings {
    tier = "db-f1-micro" # Smallest instance tier
  }
  lifecycle {
    # prevent_destroy = true
  }
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

# Create GCS for deployment
resource "google_storage_bucket" "function_bucket" {
  name          = "my-function-bucket-${var.project_id}"
  location      = "US"
  storage_class = "STANDARD"
}

data "archive_file" "default" {
  type        = "zip"
  source_dir  = "../functions"
  output_path = "./output/function-source.zip"
}

resource "google_storage_bucket_object" "function_code" {
  name   = "function-source.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = "./output/function-source.zip"
}

# Create a Cloud Function
resource "google_cloudfunctions_function" "cloud_function" {
  name        = "sample-function"
  runtime     = "go122" # Go 1.22 runtime
  region      = var.region
  entry_point = "success"

  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function_code.name

  trigger_http = true

  environment_variables = {
    CLOUD_SQL_CONNECTION_NAME = "${var.project_id}:${var.region}:${var.cloud_sql_instance_name}"
    CLOUD_SQL_USER            = var.cloud_sql_user
    CLOUD_SQL_PASSWORD        = var.cloud_sql_password
  }
}

output "function_url" {
  value = google_cloudfunctions_function.cloud_function.https_trigger_url
}

resource "google_cloud_scheduler_job" "daily_task" {
  name        = "daily-cloud-function-job"
  description = "Run cloud function daily at 3 PM"
  schedule    = "0 15 * * *" # Cron schedule for 3 PM daily
  time_zone   = "Asia/Tokyo" # Adjust as needed, e.g., "Asia/Tokyo" for JST

  retry_config {
    # Retries will occur up to 3 times with an initial 10s delay, doubling twice up to a maximum of 1 hour between attempts.
    # e.g) 1st: 10sec after failure, 2nd: 20sec after the 1st retry, 3rd: 40sec after the 2nd retry
    min_backoff_duration = "10s"
    max_backoff_duration = "3600s"
    max_doublings        = 2
    retry_count          = 3
  }
  http_target {
    http_method = "GET"
    uri         = google_cloudfunctions_function.cloud_function.https_trigger_url

    oidc_token {
      service_account_email = google_service_account.scheduler_service_account.email
    }
  }
}

resource "google_service_account" "scheduler_service_account" {
  account_id   = "scheduler-service-account"
  display_name = "Scheduler Service Account"
}

# IAM Binding for Cloud Function to access Cloud SQL
resource "google_project_iam_binding" "cloud_sql_access" {
  project = var.project_id
  role    = "roles/cloudsql.client"

  members = [
    "serviceAccount:${google_cloudfunctions_function.cloud_function.service_account_email}"
  ]
}

# IAM Binding for Cloud Tasks to trigger Cloud Function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = var.project_id
  region         = var.region
  cloud_function = google_cloudfunctions_function.cloud_function.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_cloudfunctions_function.cloud_function.service_account_email}"
}
