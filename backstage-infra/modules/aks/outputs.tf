output "cluster_id" {
  value = azurerm_kubernetes_cluster.this.id
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.this.name
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "cluster_principal_id" {
  value = azurerm_kubernetes_cluster.this.identity[0].principal_id
}

output "kubelet_object_id" {
  value = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}
