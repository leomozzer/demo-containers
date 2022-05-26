resource "azurerm_resource_group" "rg" {
  name     = "${var.app_name}-rg-website-${var.environment}"
  location = "West Europe"
}

module "acg_website" {
  source          = "../modules/acg"
  acg_name        = "website-container"
  rg_name         = azurerm_resource_group.rg.name
  rg_location     = azurerm_resource_group.rg.location
  ip_address_type = "Public"
  os_type         = "Linux"
  acr_username    = var.acr_username
  acr_password    = var.acr_password
  acr_server      = var.acr_server
  container_name  = "website-container"
  container_image = "${var.acr_server}/website:latest"
  port            = 80
  protocol        = "TCP"
}

output "website_ip_address" {
  value = module.acg_website.acg_ip_address
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "acg_name" {
  value = module.acg_website.acg_name
}
