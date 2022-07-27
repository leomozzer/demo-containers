variable "keyvault_name" {
  description = "Key Vault name"
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "enabled_for_disk_encryption" {
  type = bool
}

variable "tenant_id" {
  type = string
}

variable "soft_delete_retention_days" {
  type = number
}

variable "purge_protection_enabled" {
  type = bool
}

variable "sku_name" {
  type    = string
  default = "standard"
}

variable "access_policy" {
  type = map(any)
}

variable "object_id" {
  type = string
}
