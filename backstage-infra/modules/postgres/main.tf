data "azurerm_client_config" "current" {}

locals {
  effective_tenant_id = coalesce(var.entra_tenant_id, data.azurerm_client_config.current.tenant_id)
}

resource "azurerm_private_dns_zone" "this" {
  count = var.public_network_access_enabled ? 0 : 1

  name                = "${var.name_prefix}.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["Creator-AutoApplied"],
      tags["createdOnDate"],
    ]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  count = var.public_network_access_enabled ? 0 : 1

  name                  = "pdnslink-${var.name_prefix}"
  private_dns_zone_name = azurerm_private_dns_zone.this[0].name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
  tags                  = var.tags

  lifecycle {
    ignore_changes = [
      tags["Creator-AutoApplied"],
      tags["createdOnDate"],
    ]
  }
}

resource "random_password" "admin" {
  count            = var.password_auth_enabled ? 1 : 0
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                          = "psql-${var.name_prefix}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.postgres_version
  delegated_subnet_id           = var.public_network_access_enabled ? null : var.subnet_id
  private_dns_zone_id           = var.public_network_access_enabled ? null : azurerm_private_dns_zone.this[0].id
  public_network_access_enabled = var.public_network_access_enabled
  administrator_login           = var.password_auth_enabled ? var.admin_username : null
  administrator_password        = var.password_auth_enabled ? random_password.admin[0].result : null
  storage_mb                    = var.storage_mb
  sku_name                      = var.sku_name
  backup_retention_days         = 7
  zone                          = 2

  authentication {
    active_directory_auth_enabled = var.active_directory_auth_enabled
    password_auth_enabled         = var.password_auth_enabled
    tenant_id                     = var.active_directory_auth_enabled ? local.effective_tenant_id : null
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.this]
  tags       = var.tags

  lifecycle {
    ignore_changes = [
      tags["Creator-AutoApplied"],
      tags["createdOnDate"],
    ]
  }
}



resource "azurerm_postgresql_flexible_server_active_directory_administrator" "entra_admin" {
  count = var.active_directory_auth_enabled && var.entra_admin_object_id != "" && var.entra_admin_principal_name != "" ? 1 : 0

  server_name         = azurerm_postgresql_flexible_server.this.name
  resource_group_name = var.resource_group_name
  tenant_id           = local.effective_tenant_id
  object_id           = var.entra_admin_object_id
  principal_name      = var.entra_admin_principal_name
  principal_type      = var.entra_admin_principal_type
}

resource "azurerm_postgresql_flexible_server_database" "backstage" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
