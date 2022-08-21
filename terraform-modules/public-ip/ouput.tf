output "public_ip" {
  value = {
    "key" : "public-ip"
    "output" : azurerm_public_ip.public_ip.ip_address
  }
}

output "id" {
  value = {
    "key" : "id"
    "output" : azurerm_public_ip.public_ip.id
  }
}
