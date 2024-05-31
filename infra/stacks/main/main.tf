provider "google-beta" {
  project = var.project_id
  region  = var.region
  credentials  = var.project_key
}

variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "project_key" {
    description = "The key terraform access key of the project"
    type = string
}

variable "runtime" {
  description = "Runtime of the Cloud Function"
  type        = string
}

variable "entry_point" {
  description = "Entry point function of the Cloud Function"
  type        = string
}

variable "source_dir" {
  description = "Source directory of the Cloud Function"
  type        = string
}

variable "region" {
  description = "The region to deploy the functions to"
  type        = string
}

data "template_file" "api_config"{
  template = file("../../api-spec/api.yaml")
  vars = {
    region = var.region
    project_id = var.project_id
  }
}
resource "google_service_account" "api_service_account"{
  account_id = "api-service-account"
  display_name = "Service account for API"
}

resource "google_api_gateway_api" "template_api"{
  provider = google-beta
  api_id = "template-api"
  display_name = "Template API"
}

resource "google_api_gateway_api_config" "template_api_config" {
  provider = google-beta
  api = google_api_gateway_api.template_api.api_id
  api_config_id = "template-api-config"
  display_name = "Template API config"
  openapi_documents{
      document{
          path = "api.yaml"
          contents = base64encode(data.template_file.api_config.rendered)
      }
  }
  gateway_config{
    backend_config{
      google_service_account = google_service_account.api_service_account.email
    }
  }
}

resource "google_api_gateway_gateway" "template_gateway" {
  provider = google-beta
  gateway_id = "template-gateway"
  display_name = "Template Gateway"
  api_config = google_api_gateway_api_config.template_api_config.id
  region = var.region    
}

module "auth" {
  project_id = var.project_id
  source       = "../../../functions/auth"
  function_name = "auth_function"
  description   = "Auth Function"
  source_dir    = var.source_dir
  runtime       = var.runtime
  entry_point   = var.entry_point
  region = var.region
  api_service_account_email = google_service_account.api_service_account.email
}

module "users" {
  project_id = var.project_id
  source       = "../../../functions/users"
  function_name = "users_function"
  description   = "Users function"
  source_dir    = var.source_dir
  runtime       = var.runtime
  entry_point   = var.entry_point
  region = var.region
  api_service_account_email = google_service_account.api_service_account.email
}

output "api_url" {
  value = google_api_gateway_gateway.template_gateway.default_hostname
}

















































































































































































































