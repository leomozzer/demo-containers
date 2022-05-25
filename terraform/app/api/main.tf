resource "azurerm_resource_group" "rg" {
  name     = "${var.app_name}-rg-api-${var.environment}"
  location = "West Europe"
}

module "acg_api" {
  source          = "../modules/acg"
  acg_name        = "api-container"
  rg_name         = azurerm_resource_group.rg.name
  rg_location     = azurerm_resource_group.rg.location
  ip_address_type = "Public"
  os_type         = "Linux"
  acr_username    = var.acr_username
  acr_password    = var.acr_password
  acr_server      = var.acr_server
  container_name  = "api-container"
  container_image = "${var.acr_server}/api:latest"
  port            = 9001
  protocol        = "TCP"
}

output "api_ip_address" {
  value = module.acg_api.acg_ip_address
}
