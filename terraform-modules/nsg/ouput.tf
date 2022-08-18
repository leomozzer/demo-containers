output "network_security_group" {
  value = {
    "key" : "network-security-group"
    "output" : azurerm_network_security_rule.network_security_rule.id
  }
}

