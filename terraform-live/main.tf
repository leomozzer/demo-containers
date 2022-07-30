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
  name     = "${local.random_result}-${var.app_name}-${var.stage}-rg"
  location = var.rg_location
}

module "acr" {
  source              = "../terraform-modules/acr"
  acr_name            = "${local.random_result}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  acr_sku             = "Basic"
  admin_enabled       = true
}

module "keyvault" {
  source                      = "../terraform-modules/keyvault"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  keyvault_name               = "${local.random_result}-kv"
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
  object_id                   = data.azurerm_client_config.current.object_id
  key_permissions = [
    "Create", "Get",
  ]

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]

}

module "keyvault_secret" {
  source       = "../terraform-modules/keyvault-secret"
  for_each     = { for secret in [module.acr.admin_username, module.acr.admin_password] : secret.key => secret }
  name         = each.value.key
  value        = each.value.output
  key_vault_id = module.keyvault.key_vault_id.output
}


#https://thomasthornton.cloud/2022/01/26/deploy-to-azure-container-instance-from-azure-container-registry-using-a-ci-cd-azure-devops-pipeline-and-terraform/
#https://truestorydavestorey.medium.com/how-to-get-an-azure-container-instance-running-inside-a-vnet-with-a-fileshare-mount-using-terraform-a12f5b2b86ce
# module "azure_container_group" {
#   source              = "../terraform-modules/acg"
#   acg_name            = "${local.random_result}acg"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   ip_address_type     = "Public"
#   os_type             = "Linux"
#   acr_username        = module.acr.admin_username.output
#   acr_password        = module.acr.admin_password.output
#   acr_server          = "${module.acr.admin_username.output}.azurecr.io"
#   container_list = [{
#     name   = "sidecar"
#     image  = "mcr.microsoft.com/azuredocs/aci-tutorial-sidecar"
#     cpu    = "0.5"
#     memory = "1.5"
#     ports = [{
#       port     = 443
#       protocol = "TCP"
#     }]

#   }]
# }

# locals {
#   some = [{
#     name   = "sidecar"
#     image  = "mcr.microsoft.com/azuredocs/aci-tutorial-sidecar"
#     cpu    = "0.5"
#     memory = "1.5"
#     ports = [{
#       port     = 443
#       protocol = "TCP"
#     }]
#   }]
# }


# locals {
#   other = [for f in local.some : {
#     value = f
#   }]
#   # for_each = { for container in [module.acr.admin_username] : container.key => container }
#   # name     = each.value.key
#   # # image    = each.value.image
#   # # cpu      = each.value.cpu
#   # # memory   = each.value.memory
# }

# output "bla" {
#   value = local.other
# }
