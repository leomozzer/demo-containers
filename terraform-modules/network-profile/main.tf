resource "azurerm_network_profile" "network_profile" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  container_network_interface {
    name = "acg-nic"

    ip_configuration {
      name      = "aciipconfig"
      subnet_id = var.subnet_id
    }
  }
}
