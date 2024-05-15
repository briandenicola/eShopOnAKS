resource "azurerm_cognitive_account" "this" {
  name                = local.openai_name
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
  kind                = "OpenAI"

  sku_name            = "S0"
}