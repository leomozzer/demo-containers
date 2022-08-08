output "subnet_id" {
  value = {
    "key" : "subnet"
    "output" : azurerm_virtual_network.vnet.subnet
  }
}

