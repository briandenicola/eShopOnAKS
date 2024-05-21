resource "azurerm_resource_group" "aks" {
  name     = "${local.resource_name}_aks_rg"
  location = var.region
  tags = {
    Application = var.tags
    DeployedOn  = timestamp()
    AppName     = local.resource_name
    Tier        = "Application Kubernetes Components"
  }
}