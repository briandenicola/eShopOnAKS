data "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group_name
}

data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}
