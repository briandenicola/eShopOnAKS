resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

locals {
  resource_name                        = "${random_pet.this.id}-${random_id.this.dec}"
  openai_name                          = "${local.resource_name}-openai"
}
