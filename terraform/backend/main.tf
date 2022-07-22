resource "random_string" "random" {
  length  = 7
  special = false
  upper   = false
  numeric = false
}

locals {
  project_name  = "${var.app_name}-${random_string.random.result}"
  random_result = random_string.random.result
}

module "backend" {
  source            = "./modules"
  rg_name           = "${local.project_name}-rg-backend-${var.environment}"
  rg_location       = "West Europe"
  acr_name          = "${local.random_result}acr"
  acr_sku           = "Basic"
  acr_admin_enabled = true
  keyvault_name     = "${local.random_result}-kv"
}

output "rg_name" {
  value = "${local.project_name}-rg-backend"
}

output "acr_name" {
  value = "${local.random_result}acr"
}
