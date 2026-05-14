output "traffic_controller_id" {
  value = var.enable ? azapi_resource.traffic_controller[0].id : null
}
