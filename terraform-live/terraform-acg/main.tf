resource "random_string" "random" {
  length  = 7
  special = false
  upper   = false
  numeric = false
}

locals {
  random_result = random_string.random.result
}

module "public_ip" {
  source              = "../../terraform-modules/public-ip"
  name                = "${local.random_result}public-ip"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
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

module "network_security_group" {
  source              = "../../terraform-modules/nsg"
  name                = "${local.random_result}-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

###################
# MySql Container #
###################

module "mysql_network_security_rule" {
  depends_on = [
    module.network_security_group,
    module.apisubnet
  ]
  source                      = "../../terraform-modules/network-security-rule"
  name                        = "mysql-rule" #"from-gateway-subnet"
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = "${local.random_result}-nsg"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = [3306] #[22, 80, 443, 445, 3306, 8000, 9001]
  #source_address_prefixes      = ["0.0.0.0", "255.255.255.255"]
  #destination_address_prefixes = module.mysqlsubnet.address_prefixes.output
  source_address_prefix      = module.apisubnet.address_prefixes.output
  destination_address_prefix = module.mysqlsubnet.address_prefixes.output
}

module "mysqlsubnet" {
  depends_on = [
    module.vnet
  ]
  source                     = "../../terraform-modules/subnet"
  name                       = "mysqlsubnet"
  resource_group_name        = data.azurerm_resource_group.rg.name
  virtual_network_name       = "${local.random_result}-vnet"
  address_prefixes           = ["10.0.2.0/24"]
  delegation_name            = "acidelegationservice"
  service_delegation_name    = "Microsoft.ContainerInstance/containerGroups"
  service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
}

module "mysql_network_profile" {
  depends_on = [
    module.mysqlsubnet
  ]
  source              = "../../terraform-modules/network-profile"
  name                = "${random_string.random.result}netprofile"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.mysqlsubnet.subnet_id.output
}

module "mysql_subnet_network_security_group_association" {
  depends_on = [
    module.mysqlsubnet,
    module.network_security_group
  ]
  source                    = "../../terraform-modules/nsg-association"
  subnet_id                 = module.mysqlsubnet.subnet_id.output
  network_security_group_id = module.network_security_group.network_security_group.output
}

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

  network_profile_id = module.mysql_network_profile.id.output

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

#################
# API Container #
#################
# module "api_network_security_rule" {
#   depends_on = [
#     module.network_security_group,
#     module.apisubnet
#   ]
#   source                      = "../../terraform-modules/network-security-rule"
#   name                        = "api-rule" #"from-gateway-subnet"
#   resource_group_name         = data.azurerm_resource_group.rg.name
#   network_security_group_name = "${local.random_result}-nsg"
#   priority                    = 200
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_ranges     = [9001] #[22, 80, 443, 445, 3306, 8000, 9001]
#   #source_address_prefixes      = ["0.0.0.0", "255.255.255.255"]
#   #destination_address_prefixes = module.mysqlsubnet.address_prefixes.output
#   source_address_prefix      = module.apisubnet.address_prefixes.output
#   destination_address_prefix = module.mysqlsubnet.address_prefixes.output
# }
module "apisubnet" {
  depends_on = [
    module.vnet
  ]
  source                     = "../../terraform-modules/subnet"
  name                       = "apisubnet"
  resource_group_name        = data.azurerm_resource_group.rg.name
  virtual_network_name       = "${local.random_result}-vnet"
  address_prefixes           = ["10.0.3.0/24"]
  delegation_name            = "acidelegationservice"
  service_delegation_name    = "Microsoft.ContainerInstance/containerGroups"
  service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
}

module "api_network_profile" {
  depends_on = [
    module.mysqlsubnet
  ]
  source              = "../../terraform-modules/network-profile"
  name                = "${random_string.random.result}netprofile"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.apisubnet.subnet_id.output
}

module "api_subnet_network_security_group_association" {
  depends_on = [
    module.apisubnet,
    module.network_security_group
  ]
  source                    = "../../terraform-modules/nsg-association"
  subnet_id                 = module.apisubnet.subnet_id.output
  network_security_group_id = module.network_security_group.network_security_group.output
}
resource "azurerm_container_group" "api" {
  name                = "apiacg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_address_type     = "Private"
  os_type             = "Linux"

  network_profile_id = module.api_network_profile.id.output

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

#####################
# Website Container #
#################

# module "websitesubnet" {
#   depends_on = [
#     module.vnet
#   ]
#   source                     = "../../terraform-modules/subnet"
#   name                       = "websitesubnet"
#   resource_group_name        = data.azurerm_resource_group.rg.name
#   virtual_network_name       = "${local.random_result}-vnet"
#   address_prefixes           = ["10.0.4.0/24"]
#   delegation_name            = "acidelegationservice"
#   service_delegation_name    = "Microsoft.ContainerInstance/containerGroups"
#   service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
# }

# module "website_network_profile" {
#   depends_on = [
#     module.mysqlsubnet
#   ]
#   source              = "../../terraform-modules/network-profile"
#   name                = "${random_string.random.result}netprofile"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   subnet_id           = module.websitesubnet.subnet_id.output
# }

# module "website_subnet_network_security_group_association" {
#   depends_on = [
#     module.websitesubnet,
#     module.network_security_group
#   ]
#   source                    = "../../terraform-modules/nsg-association"
#   subnet_id                 = module.websitesubnet.subnet_id.output
#   network_security_group_id = module.network_security_group.network_security_group.output
# }
# resource "azurerm_container_group" "webiste" {
#   name                = "webisteacg"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   ip_address_type     = "Private"
#   os_type             = "Linux"

#   network_profile_id = module.website_network_profile.id.output

#   image_registry_credential {
#     username = data.azurerm_container_registry.acr.admin_username
#     password = data.azurerm_container_registry.acr.admin_password
#     server   = data.azurerm_container_registry.acr.login_server
#   }

#   #network_profile_id = module.network_profile.id.output

#   container {
#     name   = "webiste"
#     image  = "${data.azurerm_container_registry.acr.login_server}/website:latest" #"mcr.microsoft.com/azuredocs/aci-helloworld:latest"
#     cpu    = "0.5"
#     memory = "1.5"

#     ports {
#       port     = 80
#       protocol = "TCP"
#     }

#     environment_variables = {
#       "BACKEND_ADDRESS" = azurerm_container_group.api.ip_address
#       "MYSQL_PORT"      = 3306
#     }
#   }
#   tags = {
#     environment = "testing"
#   }
# }

output "subnet" {
  value = module.mysqlsubnet
}

output "nsg" {
  value = module.network_security_group.network_security_group
}

# output "name" {
#   value = module.network_profile.id.output
# }
