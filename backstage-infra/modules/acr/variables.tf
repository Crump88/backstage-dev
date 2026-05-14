variable "name_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku" {
  type = string
}

variable "admin_enabled" {
  type = bool
}

variable "tags" {
  type    = map(string)
  default = {}
}
