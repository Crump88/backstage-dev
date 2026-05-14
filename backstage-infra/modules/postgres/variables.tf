variable "name_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type    = string
  default = null

  validation {
    condition     = var.public_network_access_enabled || (var.subnet_id != null && trimspace(var.subnet_id) != "")
    error_message = "subnet_id must be set when public_network_access_enabled is false."
  }
}

variable "vnet_id" {
  type    = string
  default = null

  validation {
    condition     = var.public_network_access_enabled || (var.vnet_id != null && trimspace(var.vnet_id) != "")
    error_message = "vnet_id must be set when public_network_access_enabled is false."
  }
}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}

variable "sku_name" {
  type = string
}

variable "postgres_version" {
  type = string
}

variable "active_directory_auth_enabled" {
  type    = bool
  default = true
}

variable "password_auth_enabled" {
  type    = bool
  default = false
}

variable "entra_tenant_id" {
  type    = string
  default = null
}

variable "entra_admin_object_id" {
  type    = string
  default = ""
}

variable "entra_admin_principal_name" {
  type    = string
  default = ""
}

variable "entra_admin_principal_type" {
  type    = string
  default = "Group"
}

variable "storage_mb" {
  type = number
}

variable "admin_username" {
  type = string
}

variable "database_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
