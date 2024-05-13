resource "azurerm_kubernetes_cluster_node_pool" "app_node_pool" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

  name                  = "apps"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vnet_subnet_id        = azurerm_subnet.kubernetes.id
  vm_size               = var.vm_size
  enable_auto_scaling   = true
  mode                  = "User"
  os_sku                = "Mariner"
  os_disk_size_gb       = 127
  max_pods              = 250
  node_count            = var.node_count
  min_count             = var.node_count
  max_count             = var.node_count + 2
  zones                 = local.zones

  upgrade_settings {
    max_surge = "25%"
  }
}