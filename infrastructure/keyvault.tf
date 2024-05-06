
resource "azurerm_key_vault" "this" {
  name                        = local.kv_name
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true

  sku_name                    = "standard"

  network_acls {
    bypass                    = "AzureServices"
    default_action            = "Deny"
    ip_rules                  = ["${chomp(data.http.myip.response_body)}/32"] 
  }
}

resource "azurerm_private_endpoint" "key_vault" {
  name                      = "${local.kv_name}-ep"
  resource_group_name       = azurerm_resource_group.this.name
  location                  = azurerm_resource_group.this.location
  subnet_id                 = azurerm_subnet.private-endpoints.id

  private_service_connection {
    name                           = "${local.kv_name}-ep"
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = [ "vault" ]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                          = azurerm_private_dns_zone.privatelink_vaultcore_azure_net.name
    private_dns_zone_ids          = [ azurerm_private_dns_zone.privatelink_vaultcore_azure_net.id ]
  }
}

resource "azurerm_key_vault_certificate" "this" {
  name         = var.certificate_name
  key_vault_id = azurerm_key_vault.this.id

  depends_on = [
    azurerm_kubernetes_cluster.this,
    azurerm_role_assignment.deployer_kv_access
  ]

  certificate {
    contents = var.certificate_base64_encoded
    password = var.certificate_password
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}