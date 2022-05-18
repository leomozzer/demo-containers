resource "azurerm_container_group" "example" {
  name                = var.acg_name
  location            = var.rg_location
  resource_group_name = var.rg_name
  ip_address_type     = var.ip_address_type
  os_type             = var.os_type

  image_registry_credential {
    username = var.acr_username
    password = var.acr_password
    server   = var.acr_server
  }

  container {
    name   = var.container_name
    image  = var.container_image
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = var.port
      protocol = var.protocol
    }
  }
}
