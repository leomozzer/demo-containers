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
}

# resource "azurerm_subnet" "subnet" {
#   name                 = "acrsubnet"
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.2.0/24"]
#   delegation {
#     name = "acidelegationservice"

#     service_delegation {
#       name    = "Microsoft.ContainerInstance/containerGroups"
#       actions = ["Microsoft.Network/virtualNetworks/subnets/action", "Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
#     }
#   }
# }

##Addnew security rule

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

#     destination_port_ranges    = [22, 443, 445, 3306, 8000]
#     source_address_prefixes    = ["10.0.0.0/16"]
#     destination_address_prefix = azurerm_subnet.subnet.address_prefixes[0]
#   }
#   security_rule {
#     name              = "to-internet"
#     priority          = 100
#     direction         = "Outbound"
#     access            = "Allow"
#     protocol          = "Tcp"
#     source_port_range = "*"

#     destination_port_ranges    = [80, 443, 445]
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# resource "azurerm_network_security_rule" "example" {
#   name                        = "test123"
#   priority                    = 101
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.network_security_group.name
# }

# resource "azurerm_subnet_network_security_group_association" "sn-nsg-aci" {
#   subnet_id                 = azurerm_subnet.subnet.id #azurerm_virtual_network.vnet.subnet.*.id[0]
#   network_security_group_id = azurerm_network_security_group.network_security_group.id
# }
