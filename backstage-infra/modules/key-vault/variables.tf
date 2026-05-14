variable "name_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "key_vault_name" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
