resource "azurerm_resource_group" "rg" {
  name     = "acr-rg"
  location = "West Europe"
}

module "acg_mysql" {
  source          = "./modules/acg"
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

module "acg_mysql" {
  source          = "./modules/acg"
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

# resource "azurerm_container_group" "example" {
#   name                = "example-continst"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   ip_address_type     = "Public"
#   os_type             = "Linux"

#   image_registry_credential {
#     username = var.acr_username
#     password = var.acr_password
#     server   = var.acr_server
#   }

#   container {
#     name   = "api-container"
#     image  = "zorfexkacr.azurecr.io/api:latest"
#     cpu    = "0.5"
#     memory = "1.5"

#     ports {
#       port     = 9001
#       protocol = "TCP"
#     }
#   }

#   tags = {
#     environment = "testing"
#   }
# }
