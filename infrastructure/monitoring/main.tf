locals {
  resource_name                        = var.app_name
  azuremonitor_workspace_name          = "${local.resource_name}-logs"
  ai_name                              = "${local.resource_name}-appinsights"
  la_name                              = "${local.resource_name}-logs"
 
  azure_monitor_workspace_location     = "westus2"

}
