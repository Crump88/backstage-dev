data "azurerm_client_config" "current" {}

resource "azurerm_user_assigned_identity" "backstage" {
  name                = "id-${var.name_prefix}-backstage"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["Creator-AutoApplied"],
      tags["createdOnDate"],
    ]
  }
}

resource "azurerm_federated_identity_credential" "backstage" {
  name                = "fic-${var.name_prefix}-backstage"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.backstage.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
}

resource "azurerm_role_assignment" "blob_data_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.backstage.principal_id
}

resource "azurerm_role_assignment" "key_vault_secrets_user" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.backstage.principal_id
}
