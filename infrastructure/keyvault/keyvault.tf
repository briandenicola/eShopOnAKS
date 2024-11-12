
resource "azurerm_key_vault" "this" {
  name                       = local.kv_name
  resource_group_name        = var.keyvault_resource_group_name
  location                   = var.region
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  enable_rbac_authorization  = true

  sku_name = "standard"

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = ["${chomp(data.http.myip.response_body)}/32"]
  }
}

resource "azurerm_private_endpoint" "key_vault" {
  name                = "${local.kv_name}-ep"
  resource_group_name = var.keyvault_resource_group_name
  location            = var.region
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${local.kv_name}-ep"
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.privatelink_vaultcore_azure_net.name
    private_dns_zone_ids = [azurerm_private_dns_zone.privatelink_vaultcore_azure_net.id]
  }
}
