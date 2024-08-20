resource "azurerm_monitor_data_collection_rule_association" "container_insights" {
  name                        = "${local.resource_name}-ama-container-insights-rules-association"
  target_resource_id          = azurerm_kubernetes_cluster.this.id
  data_collection_rule_id     = azurerm_monitor_data_collection_rule.container_insights.id
}

resource "azurerm_monitor_data_collection_rule" "container_insights" {
  name                = "${local.aks_name}-container-insights-rules"
  resource_group_name = var.monitoring_resource_group_name
  location            = var.monitoring_location

  destinations {
    log_analytics {
      workspace_resource_id = var.azurerm_log_analytics_workspace_id
      name                  = "ciworkspace"
    }
  }

  data_flow {
    streams      = local.streams
    destinations = ["ciworkspace"]
  }

  data_sources {
    extension {
      streams        = local.streams
      extension_name = "ContainerInsights"
      extension_json = jsonencode({
        "dataCollectionSettings" : {
          "interval" : "1m",
          "namespaceFilteringMode" : "Off",
          "namespaces" : ["*"],
          "enableContainerLogV2" : true
        }
      })
      name = "ContainerInsightsExtension"
    }
  }
}
