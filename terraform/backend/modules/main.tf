resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
}

resource "azurerm_key_vault" "keyvault" {
  name                        = var.keyvault_name
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
      "Purge",
      "Recover",
      "Restore",
      "Update"
    ]

    secret_permissions = [
      "Set",
      "Get",
      "List",
      "Delete",
      "Purge",
      "Recover"
    ]

    storage_permissions = ["Get", "List", "Update", "Purge"]
  }

  network_acls {
    bypass = "AzureServices"
    default_action = "Deny"
  }
}

#tfsec:ignore:azure-keyvault-content-type-for-secret #tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "secret_acr_name" {
  name         = "acr-name"
  value        = azurerm_container_registry.acr.name
  key_vault_id = azurerm_key_vault.keyvault.id
}

#tfsec:ignore:azure-keyvault-content-type-for-secret #tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "secret_arc_admin_user" {
  count        = var.acr_admin_enabled ? 1 : 0
  name         = "arc-admin-user"
  value        = azurerm_container_registry.acr.admin_username
  key_vault_id = azurerm_key_vault.keyvault.id
}

#tfsec:ignore:azure-keyvault-content-type-for-secret #tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "secret_acr_admin_password" {
  count        = var.acr_admin_enabled ? 1 : 0
  name         = "acr-admin-password"
  value        = azurerm_container_registry.acr.admin_password
  key_vault_id = azurerm_key_vault.keyvault.id
}
