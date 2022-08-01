data "azurerm_client_config" "current" {
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# data "azurerm_container_registry" "acr" {
#   name                = var.acr_name
#   resource_group_name = data.azurerm_resource_group.rg.name
# }
