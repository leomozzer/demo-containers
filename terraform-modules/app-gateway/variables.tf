variable "name" {
  type = string
}

variable "virtual_network_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "address_prefixes" {
  type = list(string)
}

variable "sku_name" {
  type = string
}

variable "sku_tier" {
  type = string
}

variable "sku_capacity" {
  type    = number
  default = 1
}

variable "gateway_ip_configuration_name" {
  type = string
}
# variable "gateway_ip_configuration_subnet_id" {
#   type = string
# }

variable "frontend_port_name" {
  type = string
}

variable "frontend_port" {
  type = number
}

variable "frontend_ip_configuration_name" {
  type = string
}

variable "frontend_ip_configuration_public_ip_address_id" {
  type = string
}

variable "backend_address_pool_name" {
  type = string
}

variable "backend_http_settings_name" {
  type = string
}

variable "backend_http_settings_cookie_based_affinity" {
  type = string
}

variable "backend_http_settings_path" {
  type = string
}

variable "backend_http_settings_port" {
  type = number
}

variable "backend_http_settings_protocol" {
  type = string
}

variable "backend_http_settings_request_timeout" {
  type = number
}

variable "http_listener_name" {
  type = string
}

variable "http_listener_frontend_ip_configuration_name" {
  type = string
}

variable "http_listener_frontend_port_name" {
  type = string
}

variable "http_listener_protocol" {
  type = string
}

variable "request_routing_rule_name" {
  type = string
}

variable "request_routing_rule_type" {
  type = string
}

variable "request_routing_http_listener_name" {
  type = string
}

variable "request_routing_backend_address_pool_name" {
  type = string
}

variable "request_routing_backend_http_settings_name" {
  type = string
}

variable "request_routing_rule_priority" {
  type = number
}
