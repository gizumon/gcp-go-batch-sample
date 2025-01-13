variable "project_id" {
  description = "The ID of the GCP project."
  type        = string
}

variable "region" {
  description = "The region where resources will be created."
  type        = string
}

variable "cloud_sql_instance_name" {
  description = "The name of the Cloud SQL instance."
  type        = string
}

variable "cloud_sql_user" {
  description = "The username for the Cloud SQL instance."
  type        = string
}

variable "cloud_sql_password" {
  description = "The password for the Cloud SQL instance."
  type        = string
}

variable "image" {
  description = "The image for the Cloud Run job application."
  type        = string
}
