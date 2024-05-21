resource "azurerm_resource_group" "core" {
  name     = "${local.resource_name}_core_rg"
  location = var.region
  tags = {
    Application = var.tags
    DeployedOn  = timestamp()
    AppName     = local.resource_name
    Tier        = "Core Networking Infrastructure Components"
  }
}