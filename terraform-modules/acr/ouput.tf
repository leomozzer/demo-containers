output "admin_username" {
  value = {
    "key" : "admin_username"
    "value" : azurerm_container_registry.acr.admin_username
  }
}

output "admin_password" {
  value = {
    "key" : "admin_username"
    "value" : azurerm_container_registry.acr.admin_password
  }
}
