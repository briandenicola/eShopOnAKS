resource "azurerm_resource_group" "app" {
  name                  = "${local.resource_name}_app_rg"
  location              = var.region
  tags                  = {
    Application         = var.tags
    DeployedOn          = timestamp()
    AppName             = local.resource_name
    Tier                = "Application Infrastructure Components"
  }
}

resource "azurerm_resource_group" "core" {
  name                  = "${local.resource_name}_core_rg"
  location              = var.region
  tags                  = {
    Application         = var.tags
    DeployedOn          = timestamp()
    AppName             = local.resource_name
    Tier                = "Application Core Components"
  }
}

resource "azurerm_resource_group" "aks" {
  name                  = "${local.resource_name}_aks_rg"
  location              = var.region
  tags                  = {
    Application         = var.tags
    DeployedOn          = timestamp()
    AppName             = local.resource_name
    Tier                = "Application Kubernetes Components"
  }
}

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

resource "azurerm_resource_group" "chaos" {
  name                  = "${local.resource_name}_chaos_rg"
  location              = local.azure_chaos_studio_location
  tags                  = {
    Application         = var.tags
    DeployedOn          = timestamp()
    AppName             = local.resource_name
    Tier                = "Application Experimental Components"
  }
}