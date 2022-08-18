output "network_security_group" {
  value = {
    "key" : "network-security-group"
    "output" : azurerm_network_security_group.network_security_group.id
  }
}

