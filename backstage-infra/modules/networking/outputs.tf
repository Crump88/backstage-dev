output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "resource_group_id" {
  value = azurerm_resource_group.this.id
}

output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks.id
}

output "postgres_subnet_id" {
  value = azurerm_subnet.postgres.id
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway.id
}
