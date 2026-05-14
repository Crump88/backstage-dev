data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                          = coalesce(var.key_vault_name, "kv${replace(var.name_prefix, "-", "")}")
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  purge_protection_enabled      = true
  soft_delete_retention_days    = 90
  public_network_access_enabled = true
  enable_rbac_authorization     = true
  tags                          = var.tags
}
