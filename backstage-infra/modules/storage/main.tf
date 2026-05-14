resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_storage_account" "this" {
  name                     = substr(replace("st${var.name_prefix}${random_string.suffix.result}", "-", ""), 0, 24)
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_storage_container" "backstage" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}
