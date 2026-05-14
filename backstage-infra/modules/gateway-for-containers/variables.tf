variable "enable" {
  type = bool
}

variable "name_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_id" {
  type = string
}

variable "gateway_subnet_id" {
  type = string
}

variable "aks_cluster_id" {
  type = string
}

variable "gateway_extension_type" {
  type = string
}

variable "cluster_principal_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
