variable "name_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_cidr" {
  type = string
}

variable "aks_subnet_cidr" {
  type = string
}

variable "postgres_subnet_cidr" {
  type = string
}

variable "gateway_subnet_cidr" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
