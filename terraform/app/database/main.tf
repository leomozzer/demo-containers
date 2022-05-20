resource "random_string" "random" {
  length  = 7
  special = false
  upper   = false
  number  = false
}

locals {
  project_name  = "${var.app_name}-${random_string.random.result}"
  random_result = random_string.random.result
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.project_name}-rg-mysql"
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
