variable "name_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "oidc_issuer_url" {
  type = string
}

variable "storage_account_id" {
  type = string
}

variable "key_vault_id" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
