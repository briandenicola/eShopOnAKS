terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2"
    }
  }
}