output "server_id" {
  value = azurerm_postgresql_flexible_server.this.id
}

output "server_fqdn" {
  value = azurerm_postgresql_flexible_server.this.fqdn
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.backstage.name
}

output "admin_username" {
  value = azurerm_postgresql_flexible_server.this.administrator_login
}

output "admin_password" {
  value     = var.password_auth_enabled ? random_password.admin[0].result : null
  sensitive = true
}

output "entra_auth_enabled" {
  value = var.active_directory_auth_enabled
}
