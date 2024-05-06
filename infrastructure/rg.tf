resource "azurerm_resource_group" "this" {
  name                  = "${local.resource_name}_rg"
  location              = var.region
  tags                  = {
    Application         = var.tags
    DeployedOn          = timestamp()
    AppName             = local.resource_name
    Tier                = "Application Components"
  }
}

resource "azurerm_resource_group" "ui" {
  name                  = "${local.resource_name}_ui_rg"
  location              = var.region
  tags                  = {
    Application         = var.tags
    DeployedOn          = timestamp()
    AppName             = local.resource_name
    Tier                = "UI"
  }
}