resource "azurerm_resource_group" "rg" {
  name     = "${var.app_name}}-rg-mysql"
  location = "West Europe"
}

module "acg_mysql" {
  source          = "../modules/acg"
  acg_name        = "mysql-container"
  rg_name         = azurerm_resource_group.rg.name
  rg_location     = azurerm_resource_group.rg.location
  ip_address_type = "Public"
  os_type         = "Linux"
  acr_username    = var.acr_username
  acr_password    = var.acr_password
  acr_server      = var.acr_server
  container_name  = "mysql-container"
  container_image = "${var.acr_server}/mysql:latest"
  port            = 3306
  protocol        = "TCP"
}

output "mysql_ip_address" {
  value = module.acg_mysql.ip_address
}
