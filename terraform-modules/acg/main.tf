resource "azurerm_container_group" "acg" {
  name                = var.acg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = var.ip_address_type
  os_type             = var.os_type

  image_registry_credential {
    username = var.acr_username
    password = var.acr_password
    server   = var.acr_server
  }


  # container {
  #   for_each = { for container in var.container_list : container => container }
  # }
  # container {
  #   for_each = { for container in var.container_list : container.name => container }
  #   name     = each.value.name
  #   image    = each.value.image
  #   cpu      = each.value.cpu
  #   memory   = each.value.memory

  #   ports {
  #     for_each = { for index in each.value.ports : index.port => index }
  #     port     = each.value.port
  #     protocol = each.value.protocol
  #   }
  #   # name   = var.container_name
  #   # image  = var.container_image
  #   # cpu    = "0.5"
  #   # memory = "1.5"

  #   # ports {
  #   #   port     = var.port
  #   #   protocol = var.protocol
  #   # }
  # }
}
