variable "core_region" {
  description = "The location for the core of this application"
}

variable "app_name" {
  description = "The root name for this application deployment"
}

variable "tags" {
  description = "Tags to apply to Resource Group"
}

variable "app_identity_principal_id" {
  description = "The Managed Identity Principal ID"
}