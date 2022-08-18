resource "azurerm_subnet_network_security_group_association" "sn-nsg-aci" {
  subnet_id                 = var.subnet_id                 #azurerm_subnet.subnet.id #azurerm_virtual_network.vnet.subnet.*.id[0]
  network_security_group_id = var.network_security_group_id #azurerm_network_security_group.network_security_group.id
}
