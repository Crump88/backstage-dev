output "id" {
  value = azurerm_user_assigned_identity.backstage.id
}

output "client_id" {
  value = azurerm_user_assigned_identity.backstage.client_id
}

output "principal_id" {
  value = azurerm_user_assigned_identity.backstage.principal_id
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}
