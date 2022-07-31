output "admin_username" {
  value = {
    "key" : "admin-username"
    "output" : azurerm_container_registry.acr.admin_username
  }
}

output "admin_password" {
  value = {
    "key" : "admin-password"
    "output" : azurerm_container_registry.acr.admin_password
  }
}

output "name" {
  value = {
    "key" : "admin-password"
    "output" : azurerm_container_registry.acr.name
  }
}
