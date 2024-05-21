output "VNET_NAME" {
  value     = azurerm_virtual_network.this.name
  sensitive = false
}

output "CORE_RESOURCE_GROUP" {
  value     = azurerm_virtual_network.this.resource_group_name
  sensitive = false
}

output "PE_SUBNET_ID" {
  value     = azurerm_subnet.private-endpoints.id
  sensitive = false
}

output "SQL_SUBNET_ID" {
  value     = azurerm_subnet.sql.id
  sensitive = false
}
