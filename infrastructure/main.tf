resource "random_id" "this" {
  byte_length    = 2
}

resource "random_pet" "this" {
  length         = 1
  separator      = ""
}

resource "random_integer" "zone" {
  min            = 1
  max            = 3
}

locals {
  resource_name  = "${random_pet.this.id}-${random_id.this.dec}"
  openai_name    = "${local.resource_name}-openai"
  non_az_regions = ["northcentralus", "canadaeast", "westcentralus", "westus"]
  zones          = contains(local.non_az_regions, var.region) ? null : [ random_integer.zone.result ]
  sql_zone       = contains(local.non_az_regions, var.region) ? null : random_integer.zone.result
}
