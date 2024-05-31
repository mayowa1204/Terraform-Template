variable "function_name" {
  description = "Name of the Cloud Function"
  type        = string
}

variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "description" {
  description = "Description of the Cloud Function"
  type        = string
}

variable "source_dir" {
  description = "Source directory of the Cloud Function"
  type        = string
}

variable "runtime" {
  description = "Runtime of the Cloud Function"
  type        = string
}

variable "entry_point" {
  description = "Entry point function of the Cloud Function"
  type        = string
}

variable "region" {
  description = "The region to deploy the functions to"
  type        = string
}

variable "api_service_account_email" {
  description = "The API's service account email"
  type = string  
}

resource "google_service_account" "function_service_account"{
  account_id = "users-service-account"
  display_name = "Service account for ${var.function_name}"
}

resource "google_storage_bucket" "function_bucket" {
  name     = "${var.function_name}-functions-bucket"
  location = var.region
}

resource "google_cloudfunctions_function" "function" {
  name        = var.function_name
  description = var.description
  runtime     = var.runtime
  entry_point = var.entry_point
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function_archive.name
  trigger_http           = true
  available_memory_mb    = 128
  region                 = var.region
  service_account_email = google_service_account.function_service_account.email
}

data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  =  "${var.source_dir}/users"
  output_path = "${var.source_dir}/users/${var.function_name}.zip"
}

resource "google_storage_bucket_object" "function_archive" {
  name   = "${var.function_name}.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = data.archive_file.function_zip.output_path
}
resource "google_cloudfunctions_function_iam_member" "invoke_role"{
  project = var.project_id
  region = var.region
  cloud_function = google_cloudfunctions_function.function.name
  role = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${var.api_service_account_email}"
}
output "url" {
  value = google_cloudfunctions_function.function.https_trigger_url
}