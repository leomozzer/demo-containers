variable "acg_name" {
  description = "App environment"
  type        = string
}

variable "rg_location" {
  description = "Resource group location"
  type        = string
}

variable "rg_name" {
  description = "Resource group name"
}

variable "ip_address_type" {
  description = "Ip address type"
  type        = string
  default     = "Public"
}

variable "os_type" {
  description = "OS type"
  type        = string
  default     = "Linux"
}

variable "container_name" {
  description = "Container name"
  type        = string
}

variable "container_image" {
  description = "Container image"
  type        = string
}

variable "acr_username" {
  description = "ACR username"
}

variable "acr_password" {
  description = "ACR password"
}

variable "acr_server" {
  description = "ACR server"
}

# variable "port" {
#   description = "Port number"
#   type        = number
#   default     = 80
# }

# variable "protocol" {
#   description = "Protocol type"
#   type        = string
#   default     = "TCP"
# }

variable "container_list" {
  type = list(map(any))
}
