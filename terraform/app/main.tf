resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_container_group" "example" {
  name                = "example-continst"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  ip_address_type     = "Public"
  os_type             = "Linux"

  image_registry_credential {
    username = var.acr_username
    password = var.acr_password
    server   = var.acr_server
  }

  container {
    name   = "api-container"
    image  = "zorfexkacr.azurecr.io/api:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 9001
      protocol = "TCP"
    }
  }

  tags = {
    environment = "testing"
  }
}
