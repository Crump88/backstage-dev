resource "azurerm_kubernetes_cluster" "this" {
  name                = "aks-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-${replace(var.name_prefix, "-", "")}"
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.sku_tier

  private_cluster_enabled = var.private_cluster_enabled
  local_account_disabled  = true

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  api_server_access_profile {
    authorized_ip_ranges = var.private_cluster_enabled ? null : var.api_server_authorized_ip_ranges
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = true
    admin_group_object_ids = var.admin_group_object_ids
  }

  default_node_pool {
    name           = "system"
    vm_size        = var.node_vm_size
    node_count     = var.node_count
    vnet_subnet_id = var.subnet_id
    type           = "VirtualMachineScaleSets"
    max_pods       = 50
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = var.outbound_type
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = var.user_node_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = var.user_node_vm_size
  node_count            = var.user_node_count
  vnet_subnet_id        = var.subnet_id
  mode                  = "User"
  orchestrator_version  = var.kubernetes_version
  os_type               = "Linux"
  max_pods              = 50

  node_labels = {
    workload = "applications"
  }

  tags = var.tags
}
