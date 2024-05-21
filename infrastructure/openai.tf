resource "azurerm_cognitive_account" "this" {
  count               = var.deploy_openai ? 1 : 0
  name                = local.openai_name
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
  kind                = "OpenAI"

  sku_name = "S0"
}
