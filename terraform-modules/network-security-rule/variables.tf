
variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "network_security_group_name" {
  type = string
}

variable "priority" {
  type = number
}

variable "direction" {
  type = string
}

variable "access" {
  type = string
}

variable "protocol" {
  type = string
}

variable "source_port_range" {
  type = any
}

variable "destination_port_ranges" {
  type = any
}

# variable "source_address_prefixes" {
#   type = list(string)
# }

# variable "destination_address_prefixes" {
#   type = any
# }
