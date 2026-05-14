resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_container_registry" "this" {
  name                = substr(replace("acr${var.name_prefix}${random_string.suffix.result}", "-", ""), 0, 50)
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  tags                = var.tags
}
