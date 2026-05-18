output "alb_controller_identity_id" {
  value = var.enable ? azurerm_user_assigned_identity.alb_controller[0].id : null
}

output "alb_controller_identity_client_id" {
  value = var.enable ? azurerm_user_assigned_identity.alb_controller[0].client_id : null
}

output "alb_controller_identity_principal_id" {
  value = var.enable ? azurerm_user_assigned_identity.alb_controller[0].principal_id : null
}
