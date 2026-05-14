resource "azurerm_role_assignment" "cluster_to_gateway_subnet" {
  count = var.enable ? 1 : 0

  scope                = var.gateway_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = var.cluster_principal_id
}

resource "azurerm_kubernetes_cluster_extension" "alb" {
  count = var.enable ? 1 : 0

  name           = "agfc"
  cluster_id     = var.aks_cluster_id
  extension_type = var.gateway_extension_type

  release_train     = "stable"
  release_namespace = "azure-alb-system"

  configuration_settings = {
    "albController.namespace" = "azure-alb-system"
  }

  depends_on = [azurerm_role_assignment.cluster_to_gateway_subnet]
}

resource "azapi_resource" "traffic_controller" {
  count = var.enable ? 1 : 0

  type      = "Microsoft.ServiceNetworking/trafficControllers@2025-01-01"
  name      = "agfc-${var.name_prefix}"
  location  = var.location
  parent_id = var.resource_group_id

  schema_validation_enabled = false

  body = {
    properties = {
      associations = [
        {
          name = "default"
          subnet = {
            id = var.gateway_subnet_id
          }
        }
      ]
    }
    tags = var.tags
  }

  depends_on = [azurerm_kubernetes_cluster_extension.alb]
}
