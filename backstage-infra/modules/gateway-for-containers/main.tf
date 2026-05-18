data "azurerm_subscription" "current" {}

resource "azurerm_user_assigned_identity" "alb_controller" {
  count = var.enable ? 1 : 0

  name                = "id-${var.name_prefix}-alb-controller"
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

resource "azurerm_federated_identity_credential" "alb_controller" {
  count = var.enable ? 1 : 0

  name                = "fic-${var.name_prefix}-alb-controller"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.alb_controller[0].id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:${var.controller_namespace}:alb-controller-sa"
}

resource "azurerm_role_assignment" "alb_controller_reader_node_rg" {
  count = var.enable ? 1 : 0

  scope                = var.aks_node_resource_group_id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.alb_controller[0].principal_id
}

resource "azurerm_role_assignment" "alb_controller_config_manager_node_rg" {
  count = var.enable ? 1 : 0

  scope = var.aks_node_resource_group_id
  role_definition_id = "${data.azurerm_subscription.current.id}/providers/Microsoft.Authorization/roleDefinitions/fbc52c3f-28ad-4303-a892-8a056630b8f1"
  principal_id       = azurerm_user_assigned_identity.alb_controller[0].principal_id
}

resource "azurerm_role_assignment" "alb_controller_network_contributor_subnet" {
  count = var.enable ? 1 : 0

  scope                = var.gateway_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.alb_controller[0].principal_id
}
