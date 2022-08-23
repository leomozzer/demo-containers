resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes
}

resource "azurerm_application_gateway" "network" {
  name                = var.name                # "example-appgateway"
  resource_group_name = var.resource_group_name # azurerm_resource_group.example.name
  location            = var.location            #azurerm_resource_group.example.location

  sku {
    name     = var.sku_name     #"Standard_Small"
    tier     = var.sku_tier     #"Standard"
    capacity = var.sku_capacity #2
  }

  gateway_ip_configuration {
    name      = var.gateway_ip_configuration_name #"my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id        #var.gateway_ip_configuration_subnet_id 
  }

  frontend_port {
    name = var.frontend_port_name #local.frontend_port_name
    port = var.frontend_port      #80
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name                 #local.frontend_ip_configuration_name
    public_ip_address_id = var.frontend_ip_configuration_public_ip_address_id #azurerm_public_ip.example.id
  }

  backend_address_pool {
    name         = var.backend_address_pool_name #local.backend_address_pool_name
    ip_addresses = var.backend_address_pool_ip_addresses
  }

  backend_http_settings {
    name                  = var.backend_http_settings_name                  #local.http_setting_name
    cookie_based_affinity = var.backend_http_settings_cookie_based_affinity #"Disabled"
    path                  = var.backend_http_settings_path                  # "/path1/"
    port                  = var.backend_http_settings_port                  #80
    protocol              = var.backend_http_settings_protocol              #"Http"
    request_timeout       = var.backend_http_settings_request_timeout       #60
  }

  http_listener {
    name                           = var.http_listener_name               #local.listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name   #local.frontend_ip_configuration_name
    frontend_port_name             = var.http_listener_frontend_port_name #local.frontend_port_name
    protocol                       = var.http_listener_protocol           #"Http"
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name                  #local.request_routing_rule_name
    rule_type                  = var.request_routing_rule_type                  #"Basic"
    http_listener_name         = var.request_routing_http_listener_name         #local.listener_name
    backend_address_pool_name  = var.request_routing_backend_address_pool_name  #local.backend_address_pool_name
    backend_http_settings_name = var.request_routing_backend_http_settings_name #local.http_setting_name
    priority                   = var.request_routing_rule_priority
  }
}
