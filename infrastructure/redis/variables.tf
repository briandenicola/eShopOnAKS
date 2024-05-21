variable "region" {
  description = "The location for this application deployment"
}

variable "app_name" {
  description = "The root name for this application deployment"
}

variable "redis_resource_group_name" {
  description = "The name of the Resource Group for the KeyVault"
}

variable "vnet_name" {
  description = "The name of the VNet to attach to"
}

variable "vnet_resource_group_name" {
  description = "The name of the Resource Group for the VNet"
}

variable "subnet_id" {
  description = "The name of the Subnet to attach to"
}

variable "log_analytics_workspace_id" {
  description = "The Log Analytics Workspace ID"
}

variable "keyvault_id" {
  description = "The Resource ID of the KeyVault"
}