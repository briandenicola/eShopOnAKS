resource "azurerm_resource_group" "chaos" {
  name     = local.azure_chaos_rg_name
  location = local.azure_chaos_studio_location
  tags = {
    Application = var.tags
    DeployedOn  = timestamp()
    AppName     = local.resource_name
    Tier        = "Application Experimental Components"
  }
}