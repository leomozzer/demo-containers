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
