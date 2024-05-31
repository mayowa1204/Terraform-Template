variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
  default = "rewards-reminder"
}

variable "region" {
  description = "The region to deploy the functions to"
  type        = string
  default     = "europe-west2"
}

variable "project_key" {
    description = "The key terraform access key of the project"
    type = string
    default = "../../../../rewards-reminder-b6fcdb7a0605.json"
}