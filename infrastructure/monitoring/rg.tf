resource "azurerm_resource_group" "monitoring" {
  name                  = "${local.resource_name}_monitoring_rg"
  location              = local.azure_monitor_workspace_location
  tags                  = {
    Application         = var.tags
    DeployedOn          = timestamp()
    AppName             = local.resource_name
    Tier                = "Application Monitoring Components"
  }
}