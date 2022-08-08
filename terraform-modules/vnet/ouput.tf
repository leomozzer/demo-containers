output "subnet_id" {
  value = {
    "key" : "vnet"
    "output" : azurerm_virtual_network.vnet.subnet.id
  }
}

