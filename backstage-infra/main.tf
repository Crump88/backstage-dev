data "azurerm_client_config" "current" {}

locals {
  backstage_key_vault_id = var.existing_key_vault_id != null ? var.existing_key_vault_id : try(module.key_vault[0].id, null)
}

module "networking" {
  source = "./modules/networking"

  name_prefix          = local.base_name
  location             = var.location
  vnet_cidr            = var.vnet_cidr
  aks_subnet_cidr      = var.aks_subnet_cidr
  postgres_subnet_cidr = var.postgres_subnet_cidr
  gateway_subnet_cidr  = var.gateway_subnet_cidr
  tags                 = local.common_tags
}

module "aks" {
  source = "./modules/aks"

  name_prefix                     = local.base_name
  location                        = var.location
  resource_group_name             = module.networking.resource_group_name
  kubernetes_version              = var.kubernetes_version
  private_cluster_enabled         = var.aks_private_cluster_enabled
  api_server_authorized_ip_ranges = var.aks_api_server_authorized_ip_ranges
  sku_tier                        = var.aks_sku_tier
  admin_group_object_ids          = var.aks_admin_group_object_ids
  node_vm_size                    = var.aks_node_vm_size
  node_count                      = var.aks_node_count
  user_node_pool_name             = var.aks_user_node_pool_name
  user_node_vm_size               = var.aks_user_node_vm_size
  user_node_count                 = var.aks_user_node_count
  outbound_type                   = var.outbound_type
  subnet_id                       = module.networking.aks_subnet_id
  enable_ingress_application_gateway     = var.enable_ingress_application_gateway
  ingress_application_gateway_subnet_id  = module.networking.gateway_subnet_id
  tags                            = local.common_tags
}

module "postgres" {
  source = "./modules/postgres"

  name_prefix                    = local.base_name
  location                       = var.location
  resource_group_name            = module.networking.resource_group_name
  subnet_id                      = module.networking.postgres_subnet_id
  vnet_id                        = module.networking.vnet_id
  sku_name                       = var.postgres_sku_name
  postgres_version               = var.postgres_version
  public_network_access_enabled  = var.postgres_public_network_access_enabled
  active_directory_auth_enabled  = var.postgres_active_directory_auth_enabled
  password_auth_enabled          = var.postgres_password_auth_enabled
  entra_tenant_id                = var.postgres_entra_tenant_id
  entra_admin_object_id          = var.postgres_entra_admin_object_id
  entra_admin_principal_name     = var.postgres_entra_admin_principal_name
  entra_admin_principal_type     = var.postgres_entra_admin_principal_type
  storage_mb                     = var.postgres_storage_mb
  admin_username                 = var.postgres_admin_username
  database_name                  = var.postgres_database_name
  tags                           = local.common_tags
}

module "storage" {
  source = "./modules/storage"

  name_prefix      = local.base_name
  location         = var.location
  resource_group   = module.networking.resource_group_name
  account_tier     = var.storage_account_tier
  replication_type = var.storage_account_replication_type
  container_name   = var.storage_container_name
  tags             = local.common_tags
}

module "acr" {
  source = "./modules/acr"

  name_prefix         = local.base_name
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
  tags                = local.common_tags
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = module.acr.registry_id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_object_id
}

module "key_vault" {
  source = "./modules/key-vault"

  name_prefix          = local.base_name
  location             = var.location
  resource_group_name  = module.networking.resource_group_name
  key_vault_name       = var.key_vault_name
  tags                 = local.common_tags
}

resource "azurerm_role_assignment" "current_principal_key_vault_admin" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

module "workload_identity" {
  source = "./modules/workload-identity"

  name_prefix          = local.base_name
  location             = var.location
  resource_group_name  = module.networking.resource_group_name
  namespace            = var.backstage_namespace
  service_account_name = var.backstage_service_account_name
  oidc_issuer_url      = module.aks.oidc_issuer_url
  storage_account_id   = module.storage.storage_account_id
  key_vault_id         = module.key_vault.id
  tags                 = local.common_tags
}

module "gateway_for_containers" {
  source = "./modules/gateway-for-containers"

  enable                     = var.enable_gateway_for_containers
  name_prefix                = local.base_name
  location                   = var.location
  resource_group_name        = module.networking.resource_group_name
  gateway_subnet_id          = module.networking.gateway_subnet_id
  oidc_issuer_url            = module.aks.oidc_issuer_url
  aks_node_resource_group_id = module.aks.node_resource_group_id
  controller_namespace       = var.gateway_controller_namespace
  tags                       = local.common_tags

  depends_on = [module.aks]
}

import {
  to = module.postgres.azurerm_postgresql_flexible_server_active_directory_administrator.entra_admin[0]
  id = "/subscriptions/18fc0dae-23c8-403e-8e83-b8db9be1892c/resourceGroups/bc-testing-rg-tf/providers/Microsoft.DBforPostgreSQL/flexibleServers/psql-bc-test/administrators/945052cb-1dbb-4821-8a6a-93a4db3e0e5a"
}