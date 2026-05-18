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

variable "gateway_subnet_id" {
  type = string
}

variable "oidc_issuer_url" {
  type = string
}

variable "aks_node_resource_group_id" {
  type = string
}

variable "controller_namespace" {
  type    = string
  default = "azure-alb-system"
}

variable "tags" {
  type    = map(string)
  default = {}
}
