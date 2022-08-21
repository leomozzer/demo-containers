resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers

  subnet {
    name           = "default" #acgsubnet
    address_prefix = var.subnet_address_prefix
  }

  lifecycle {
    ignore_changes = [
      subnet
    ]
  }
}
