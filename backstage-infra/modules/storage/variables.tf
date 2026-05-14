variable "name_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "account_tier" {
  type = string
}

variable "replication_type" {
  type = string
}

variable "container_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
