output "resource_group_name" {
  value = module.networking.resource_group_name
}

output "aks_cluster_name" {
  value = module.aks.cluster_name
}

output "aks_cluster_id" {
  value = module.aks.cluster_id
}

output "aks_node_resource_group_id" {
  value = module.aks.node_resource_group_id
}

output "aks_oidc_issuer_url" {
  value = module.aks.oidc_issuer_url
}

output "postgres_server_fqdn" {
  value = module.postgres.server_fqdn
}

output "postgres_database_name" {
  value = module.postgres.database_name
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "acr_name" {
  value = module.acr.registry_name
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "backstage_workload_identity_client_id" {
  value = module.workload_identity.client_id
}

output "backstage_workload_identity_principal_id" {
  value = module.workload_identity.principal_id
}

output "backstage_key_vault_id" {
  value = local.backstage_key_vault_id
}

output "backstage_key_vault_name" {
  value = local.backstage_key_vault_id != null ? split("/", local.backstage_key_vault_id)[8] : null
}

output "gateway_for_containers_alb_controller_identity_client_id" {
  value = module.gateway_for_containers.alb_controller_identity_client_id
}

output "gateway_for_containers_alb_controller_identity_principal_id" {
  value = module.gateway_for_containers.alb_controller_identity_principal_id
}

output "gateway_for_containers_subnet_id" {
  value = module.networking.gateway_subnet_id
}
