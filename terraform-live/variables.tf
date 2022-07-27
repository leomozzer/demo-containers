variable "stage" {
  description = "App stage"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "App name"
  type        = string
}

variable "rg_location" {
  description = "Location where the resource group will be created"
  type        = string
  default     = "West Europe"
}
