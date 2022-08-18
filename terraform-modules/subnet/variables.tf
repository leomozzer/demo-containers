variable "nsg_name" {
  type = string
}

variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "virtual_network_name" {
  type = string
}

variable "address_prefixes" {
  type = list(string)
}

variable "delegation_name" {
  type = string
}

variable "service_delegation_name" {
  type = string
}

variable "service_delegation_actions" {
  type = list(string)
}
