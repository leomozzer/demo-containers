resource "azurerm_subnet" "subnet" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name #azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes
  delegation {
    name = var.delegation_name

    service_delegation {
      name    = var.service_delegation_name
      actions = var.service_delegation_actions
    }
  }
}

# resource "azurerm_network_security_group" "network_security_group" {
#   name                = var.nsg_name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   security_rule {
#     name              = "from-gateway-subnet"
#     priority          = 100
#     direction         = "Inbound"
#     access            = "Allow"
#     protocol          = "Tcp"
#     source_port_range = "*"

#     destination_port_ranges    = [22, 443, 445, 8000]
#     source_address_prefixes    = ["10.0.0.0/16"]
#     destination_address_prefix = azurerm_subnet.subnet.address_prefixes[0]
#   }
# }

# resource "azurerm_subnet_network_security_group_association" "sn-nsg-aci" {
#   subnet_id                 = azurerm_subnet.subnet.id #azurerm_virtual_network.vnet.subnet.*.id[0]
#   network_security_group_id = azurerm_network_security_group.network_security_group.id
# }
