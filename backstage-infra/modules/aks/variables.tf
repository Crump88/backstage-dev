variable "name_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "private_cluster_enabled" {
  type = bool
}

variable "api_server_authorized_ip_ranges" {
  type    = list(string)
  default = []
}

variable "sku_tier" {
  type = string
}

variable "admin_group_object_ids" {
  type    = list(string)
  default = []
}

variable "node_vm_size" {
  type = string
}

variable "node_count" {
  type = number
}

variable "user_node_pool_name" {
  type = string
}

variable "user_node_vm_size" {
  type = string
}

variable "user_node_count" {
  type = number
}

variable "outbound_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
