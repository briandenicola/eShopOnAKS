resource "azurerm_resource_group" "this" {
  name                  = "${local.resource_name}_rg"
  location              = var.region
  tags                  = {
    Application         = var.tags
    DeployedOn          = timestamp()
    AppName             = local.resource_name
    Tier                = "Application Infrastructure Components"
  }
}