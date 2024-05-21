resource "azurerm_resource_group" "app" {
  name     = "${local.resource_name}_app_rg"
  location = var.region
  tags = {
    Application = var.tags
    DeployedOn  = timestamp()
    AppName     = local.resource_name
    Tier        = "Application Infrastructure Components"
  }
}