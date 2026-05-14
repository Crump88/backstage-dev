locals {
  base_name = lower("${var.name_prefix}-${var.environment}")

  common_tags = merge(
    {
      environment = var.environment
      workload    = "backstage"
      managed_by  = "terraform"
    },
    var.tags
  )
}
