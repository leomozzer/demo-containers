resource "azurerm_network_security_rule" "network_security_rule" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  network_security_group_name  = var.network_security_group_name
  priority                     = var.priority
  direction                    = var.direction
  access                       = var.access
  protocol                     = var.protocol
  source_port_range            = var.source_port_range
  destination_port_ranges      = var.destination_port_ranges
  source_address_prefixes      = var.source_address_prefixes
  destination_address_prefixes = var.destination_address_prefixes
}
