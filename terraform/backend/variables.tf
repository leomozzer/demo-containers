variable "environment" {
  description = "App environment"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "App name"
  type        = string
}

variable "subscription_id" {
  description = "Enter the subscription_id"
}

variable "client_id" {
  description = "Enter the client_id"
}

variable "client_secret" {
  description = "Enter the client_secret"
}

variable "tenant_id" {
  description = "Enter the tenant_id"
}
