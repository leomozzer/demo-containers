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

    key_permissions = var.key_permissions

    secret_permissions = var.secret_permissions

    //certificate_permissions = var.certificate_permissions
  }

  # network_acls {
  #   bypass         = var.network_acls_bypass
  #   default_action = var.network_acls_default_action
  # }
}
