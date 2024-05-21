data "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group_name
}

data "azurerm_subnet" "kubernetes" {
  name                 = "nodes"
  resource_group_name  = var.vnet_resource_group_name
  virtual_network_name = data.azurerm_virtual_network.this.name
}

data "azurerm_subnet" "api" {
  name                 = "api-severver"
  resource_group_name  = var.vnet_resource_group_name
  virtual_network_name = data.azurerm_virtual_network.this.name
}

data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}