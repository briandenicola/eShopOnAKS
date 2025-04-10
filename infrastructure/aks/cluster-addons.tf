resource "azapi_update_resource" "cluster_updates" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

  type        = "Microsoft.ContainerService/managedClusters@2025-02-01"
  resource_id = azurerm_kubernetes_cluster.this.id

  body = jsonencode({
    properties = {
      networkProfile = {
        advancedNetworking = {
          enabled = true
          observability = {
            enabled = true
          }
        }
      }
    }
  })
}
