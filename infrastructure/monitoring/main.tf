locals {
  resource_name                    = var.app_name
  azuremonitor_workspace_name      = "${local.resource_name}-logs"
  ai_name                          = "${local.resource_name}-appinsights"
  la_name                          = "${local.resource_name}-logdb"
  azure_monitor_workspace_location = "westus2"

  streams = [
    "Microsoft-ContainerLog",
    "Microsoft-ContainerLogV2",
    "Microsoft-KubeEvents",
    "Microsoft-KubePodInventory",
    "Microsoft-KubeNodeInventory",
    "Microsoft-KubePVInventory",
    "Microsoft-KubeServices",
    "Microsoft-KubeMonAgentEvents",
    "Microsoft-InsightsMetrics",
    "Microsoft-ContainerInventory",
    "Microsoft-ContainerNodeInventory",
    "Microsoft-Perf"
  ]
}
