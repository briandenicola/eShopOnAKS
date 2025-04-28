locals {
  resource_name               = var.app_name
  azure_chaos_rg_name         = "${local.resource_name}_chaos_rg"
  azure_chaos_studio_location = "westus"
}
