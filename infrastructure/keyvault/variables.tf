variable "region" {
  description = "The location for this application deployment"
}

variable "app_name" {
  description = "The root name for this application deployment"
}

variable "keyvault_resource_group_name" {
  description = "The name of the Resource Group for the KeyVault"
}

variable "vnet_name" {
  description = "The name of the VNet to attach to"
}

variable "vnet_resource_group_name" {
  description = "The name of the Resource Group for the VNet"
}

variable "private_endpoint_subnet_id" {
  description = "The resource id of the Subnet to attach private endpoints to"
}

