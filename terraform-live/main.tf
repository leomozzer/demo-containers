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

resource "azurerm_resource_group" "rg" {
  name     = "${local.random_result}-${local.project_name}-${var.stage}-rg"
  location = var.rg_location
}

module "acr" {
  source              = "../terraform-modules/acr"
  acr_name            = "${local.random_result}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  acr_sku             = "Basic"
  admin_enabled       = true
}

module "keyvault" {
  source                      = "../terraform-modules/keyvault"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  keyvault_name               = "${local.random_result}-kv"
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 1
  purge_protection_enabled    = true
  sku_name                    = "standard"
  object_id                   = data.azurerm_client_config.current.object_id
}
