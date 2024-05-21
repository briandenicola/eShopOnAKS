output "CHAOS_RESOURCE_GROUP_NAME" {
  value     = local.azure_chaos_rg_name
  sensitive = false
}

output "CHAOS_RESOURCE_GROUP_LOCATION" {
  value     = local.azure_chaos_studio_location
  sensitive = false
}
