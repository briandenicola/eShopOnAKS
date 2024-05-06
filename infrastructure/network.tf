resource "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [ local.vnet_cidr ]
}

resource "azurerm_subnet" "private-endpoints" {
  name                  = "private-endpoints"
  resource_group_name   = azurerm_virtual_network.this.resource_group_name
  virtual_network_name  = azurerm_virtual_network.this.name
  address_prefixes      = [ local.pe_subnet_cidr ]

  private_endpoint_network_policies_enabled = true
}

resource "azurerm_subnet" "kubernetes" {
  name                  = "nodes"
  resource_group_name   = azurerm_virtual_network.this.resource_group_name
  virtual_network_name  = azurerm_virtual_network.this.name
  address_prefixes      = [ local.k8s_subnet_cidr ]
}

resource "azurerm_subnet" "api" {
  name                 = "api-severver"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [ local.api_subnet_cidir ]
  
  delegation {
    name = "aks-delegation"

    service_delegation {
      name    = "Microsoft.ContainerService/managedClusters"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]  
    }
  }
}

resource "azurerm_subnet" "sql" {
  name                  = "sql"
  resource_group_name   = azurerm_virtual_network.this.resource_group_name
  virtual_network_name  = azurerm_virtual_network.this.name
  address_prefixes      = [ local.sql_subnet_cidr ]
  service_endpoints     = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

