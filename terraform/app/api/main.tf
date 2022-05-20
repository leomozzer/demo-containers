# resource "random_string" "random" {
#   length  = 7
#   special = false
#   upper   = false
#   number  = false
# }

# locals {
#   project_name  = "${var.app_name}-${random_string.random.result}"
#   random_result = random_string.random.result
# }

resource "azurerm_resource_group" "rg" {
  name     = "${var.app_name}}-rg-mysql"
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
