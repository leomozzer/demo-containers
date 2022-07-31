resource "random_string" "random" {
  length  = 7
  special = false
  upper   = false
  numeric = false
}

locals {
  #project_name  = "${var.app_name}-${random_string.random.result}"
  random_result = random_string.random.result
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name #"${local.random_result}-${var.app_name}-${var.stage}-rg"
  location = var.rg_location
}

module "acr" {
  source              = "../../terraform-modules/acr"
  acr_name            = "${local.random_result}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  acr_sku             = "Basic"
  admin_enabled       = true
}

module "keyvault" {
  source                      = "../../terraform-modules/keyvault"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  keyvault_name               = "${local.random_result}-kv"
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
  object_id                   = data.azurerm_client_config.current.object_id
  key_permissions = [
    "Create", "Get",
  ]

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]

}

module "keyvault_secret" {
  source       = "../terraform-modules/keyvault-secret"
  for_each     = { for secret in [module.acr.admin_username, module.acr.admin_password] : secret.key => secret }
  name         = each.value.key
  value        = each.value.output
  key_vault_id = module.keyvault.key_vault_id.output
}
