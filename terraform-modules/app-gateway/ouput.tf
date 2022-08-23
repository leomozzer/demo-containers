output "subnet_id" {
  value = {
    "key" : "subnet-id"
    "output" : azurerm_subnet.frontend.id
  }
}

output "address_prefixes" {
  value = {
    "key" : "address-prefixes"
    "output" : azurerm_subnet.frontend.address_prefixes
  }
}
