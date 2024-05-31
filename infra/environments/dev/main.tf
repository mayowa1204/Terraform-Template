provider "google" {
  project = var.project_id
  region  = var.region
  credentials  = var.project_key
}

module "main" {
  project_key = var.project_key
  project_id = var.project_id
  source       = "../../stacks/main"
  source_dir    = "${path.root}/../../../functions"
  runtime      = "python39"
  entry_point  = "main"
  region = var.region
}

output "api_url" {
  value = module.main.api_url
}