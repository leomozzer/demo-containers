resource "random_string" "random" {
  length  = 7
  special = false
  upper   = false
  numeric = false
}

locals {
  #project_name  = "${var.app_name}-${random_string.random.result}"
  random_result = random_string.random.result
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name #"${local.random_result}-${var.app_name}-${var.stage}-rg"
  location = var.rg_location
}

module "acr" {
  source              = "../../terraform-modules/acr"
  acr_name            = "${local.random_result}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  acr_sku             = "Basic"
  admin_enabled       = true
}

# module "vnet" {
#   source              = "../../terraform-modules/vnet"
#   nsg_name            = "${local.random_result}nsg"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   vnet_name           = "${local.random_result}-vnet"
# }

# module "public_ip" {
#   source              = "../../terraform-modules/public-ip"
#   name                = "${local.random_result}public-ip"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
# }

# module "network_profile" {
#   source              = "../../terraform-modules/network-profile"
#   name                = "${local.random_result}netprofile"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = module.vnet.subnet.output.id
# }

# resource "azurerm_container_group" "example" {
#   name                = "example-continst"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   ip_address_type     = "Private"
#   os_type             = "Linux"

#   network_profile_id = module.network_profile.id.output

#   container {
#     name   = "hello-world"
#     image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
#     cpu    = "0.5"
#     memory = "1.5"

#     ports {
#       port     = 443
#       protocol = "TCP"
#     }
#   }

#   container {
#     name   = "sidecar"
#     image  = "mcr.microsoft.com/azuredocs/aci-tutorial-sidecar"
#     cpu    = "0.5"
#     memory = "1.5"
#   }

#   tags = {
#     environment = "testing"
#   }
# }

# module "keyvault" {
#   source                      = "../../terraform-modules/keyvault"
#   resource_group_name         = azurerm_resource_group.rg.name
#   location                    = azurerm_resource_group.rg.location
#   keyvault_name               = "${local.random_result}-kv"
#   enabled_for_disk_encryption = true
#   tenant_id                   = data.azurerm_client_config.current.tenant_id
#   soft_delete_retention_days  = 7
#   purge_protection_enabled    = false
#   sku_name                    = "standard"
#   object_id                   = data.azurerm_client_config.current.object_id
#   key_permissions = [
#     "Create", "Get",
#   ]

#   secret_permissions = [
#     "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
#   ]

# }

# module "keyvault_secret" {
#   source       = "../../terraform-modules/keyvault-secret"
#   for_each     = { for secret in [module.acr.admin_username, module.acr.admin_password] : secret.key => secret }
#   name         = each.value.key
#   value        = each.value.output
#   key_vault_id = module.keyvault.key_vault_id.output
# }


# ACI_IP=$(az container show \
#   --name apiacg \
#   --resource-group "demo-containers-dev" \
#   --query ipAddress.ip --output tsv)

# az network application-gateway create \
#   --name myAppGateway \
#   --location westeurope \
#   --resource-group "demo-containers-dev" \
#   --capacity 2 \
#   --sku Standard_v2 \
#   --http-settings-protocol http \
#   --public-ip-address "lpfxiqcpublic-ip" \
#   --vnet-name "lpfxiqc-vnet" \
#   --subnet "default" \
#   --servers "10.0.2.5" \
#   --priority 200 \
#   --routing-rule-type Basic
