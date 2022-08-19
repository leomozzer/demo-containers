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
  source                = "../../terraform-modules/vnet"
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  vnet_name             = "${local.random_result}-vnet"
  address_space         = ["10.0.0.0/16"]
  dns_servers           = ["10.0.0.4", "10.0.0.5"]
  subnet_address_prefix = "10.0.1.0/24"
}

module "acrsubnet" {
  depends_on = [
    module.vnet
  ]
  source                     = "../../terraform-modules/subnet"
  name                       = "acrsubnet"
  resource_group_name        = data.azurerm_resource_group.rg.name
  virtual_network_name       = "${local.random_result}-vnet"
  address_prefixes           = ["10.0.2.0/24"]
  delegation_name            = "acidelegationservice"
  service_delegation_name    = "Microsoft.ContainerInstance/containerGroups"
  service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
}

module "network_security_group" {
  source              = "../../terraform-modules/nsg"
  name                = "${local.random_result}-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

output "subnet" {
  value = module.acrsubnet
}

output "nsg" {
  value = module.network_security_group.network_security_group
}

module "network_security_rule" {
  source                      = "../../terraform-modules/network-security-rule"
  name                        = "from-gateway-subnet"
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = "${local.random_result}-nsg"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = [22, 443, 445, 3306, 8000]
  #source_address_prefixes      = ["0.0.0.0", "255.255.255.255"]
  #destination_address_prefixes = module.acrsubnet.address_prefixes.output
}

module "network_profile" {
  source              = "../../terraform-modules/network-profile"
  name                = "${local.random_result}netprofile"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.acrsubnet.subnet_id.output
}

module "subnet_network_security_group_association" {
  source                    = "../../terraform-modules/nsg-association"
  subnet_id                 = module.acrsubnet.subnet_id.output
  network_security_group_id = module.network_security_group.network_security_group.output
}

# output "name" {
#   value = module.network_profile.id.output
# }

# module "public_ip" {
#   source              = "../../terraform-modules/public-ip"
#   name                = "${local.random_result}public-ip"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   location            = data.azurerm_resource_group.rg.location
# }

resource "azurerm_container_group" "mysql" {
  name                = "mysqlacg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_address_type     = "Private"
  os_type             = "Linux"

  image_registry_credential {
    username = data.azurerm_container_registry.acr.admin_username
    password = data.azurerm_container_registry.acr.admin_password
    server   = data.azurerm_container_registry.acr.login_server
  }

  network_profile_id = module.network_profile.id.output

  container {
    name   = "mysql"
    image  = "${data.azurerm_container_registry.acr.login_server}/mysql:latest" #"mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 3306
      protocol = "TCP"
    }
  }
  tags = {
    environment = "testing"
  }
}

resource "azurerm_container_group" "api" {
  name                = "apiacg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  os_type             = "Linux"

  image_registry_credential {
    username = data.azurerm_container_registry.acr.admin_username
    password = data.azurerm_container_registry.acr.admin_password
    server   = data.azurerm_container_registry.acr.login_server
  }

  #network_profile_id = module.network_profile.id.output

  container {
    name   = "api"
    image  = "${data.azurerm_container_registry.acr.login_server}/api:latest" #"mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 9001
      protocol = "TCP"
    }

    environment_variables = {
      "MYSQL_HOST" = azurerm_container_group.mysql.ip_address
      "MYSQL_PORT" = 3306
    }
  }
  tags = {
    environment = "testing"
  }
}
