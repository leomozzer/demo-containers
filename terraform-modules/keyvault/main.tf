resource "azurerm_key_vault" "keyvault" {
  name                        = var.keyvault_name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = var.purge_protection_enabled

  sku_name = "standard"

  access_policy {
    #tenant_id = data.azurerm_client_config.current.tenant_id
    tenant_id = var.tenant_id
    #object_id = data.azurerm_client_config.current.object_id
    object_id = var.object_id

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
    bypass         = "AzureServices"
    default_action = "Deny"
  }
}
