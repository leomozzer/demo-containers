output "key_vault_id" {
  value = {
    "key" : "key_vault_id"
    "value" : azurerm_key_vault.keyvault.id
  }
}
