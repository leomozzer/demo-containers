resource "random_string" "random" {
  length  = 7
  special = false
  upper   = false
  numeric = false
}

locals {
  random_result = random_string.random.result
}

module "vnet" {
  source              = "../../terraform-modules/vnet"
  nsg_name            = "${local.random_result}nsg"
  location            = data.data.azurerm_resource_group.rg.location #azurerm_resource_group.rg.location
  resource_group_name = data.data.azurerm_resource_group.rg.name
  vnet_name           = "${local.random_result}-vnet"
}

module "public_ip" {
  source              = "../../terraform-modules/public-ip"
  name                = "${local.random_result}public-ip"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
}

module "network_profile" {
  source              = "../../terraform-modules/network-profile"
  name                = "${local.random_result}netprofile"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.vnet.subnet.output.id
}
