output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "acr_name" {
  value = module.acr.name
}
