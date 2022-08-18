resource "azurerm_network_security_group" "network_security_group" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  # security_rule {
  #   name              = "from-gateway-subnet"
  #   priority          = 100
  #   direction         = "Inbound"
  #   access            = "Allow"
  #   protocol          = "Tcp"
  #   source_port_range = "*"

  #   destination_port_ranges    = [22, 443, 445, 8000]
  #   source_address_prefixes    = ["10.0.0.0/16"]
  #   destination_address_prefix = azurerm_subnet.subnet.address_prefixes[0]
  # }
}

# resource "azurerm_network_security_rule" "network_security_rule" {
#   name                        = var.name
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = var.network_security_group_name
#   priority                    = var.priority
#   direction                   = var.direction
#   access                      = var.access
#   protocol                    = var.protocol
#   source_port_ranges          = var.source_port_range
#   destination_port_range      = var.
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
# }

# # resource "azurerm_subnet_network_security_group_association" "sn-nsg-aci" {
# #   subnet_id                 = azurerm_subnet.subnet.id #azurerm_virtual_network.vnet.subnet.*.id[0]
# #   network_security_group_id = azurerm_network_security_group.network_security_group.id
# # }
