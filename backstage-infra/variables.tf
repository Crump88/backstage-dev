variable "name_prefix" {
  description = "Prefix used for resource naming."
  type        = string
  default     = "bc"
}

variable "environment" {
  description = "Environment short name (for example: test, dev, prod)."
  type        = string
  default     = "test"
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "eastus"
}

variable "kubernetes_version" {
  description = "AKS version."
  type        = string
  default     = "1.30"
}

variable "aks_private_cluster_enabled" {
  description = "Set true for private AKS API server, false for public."
  type        = bool
  default     = false
}

variable "aks_api_server_authorized_ip_ranges" {
  description = "Optional list of CIDR blocks for AKS API server access when public."
  type        = list(string)
  default     = []
}

variable "aks_sku_tier" {
  description = "AKS control plane SKU tier."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.aks_sku_tier)
    error_message = "aks_sku_tier must be Free, Standard, or Premium."
  }
}

variable "aks_admin_group_object_ids" {
  description = "Entra group object IDs granted AKS admin access for kubectl bootstrap and operations."
  type        = list(string)
  default     = []
}

variable "aks_node_vm_size" {
  description = "AKS system node pool VM size."
  type        = string
  default     = "Standard_D4s_v5"
}

variable "aks_node_count" {
  description = "AKS system node pool node count."
  type        = number
  default     = 2
}

variable "aks_user_node_pool_name" {
  description = "Name of the AKS user node pool for application workloads."
  type        = string
  default     = "userpool"
}

variable "aks_user_node_vm_size" {
  description = "AKS user node pool VM size for Backstage workloads."
  type        = string
  default     = "Standard_B2s"
}

variable "aks_user_node_count" {
  description = "AKS user node pool node count for Backstage workloads."
  type        = number
  default     = 1
}

variable "outbound_type" {
  description = "AKS outbound type."
  type        = string
  default     = "loadBalancer"

  validation {
    condition     = contains(["loadBalancer", "managedNATGateway", "userAssignedNATGateway", "userDefinedRouting"], var.outbound_type)
    error_message = "outbound_type must be one of loadBalancer, managedNATGateway, userAssignedNATGateway, userDefinedRouting."
  }
}

variable "vnet_cidr" {
  description = "Virtual network CIDR."
  type        = string
  default     = "10.30.0.0/16"
}

variable "aks_subnet_cidr" {
  description = "AKS subnet CIDR."
  type        = string
  default     = "10.30.1.0/24"
}

variable "postgres_subnet_cidr" {
  description = "PostgreSQL delegated subnet CIDR."
  type        = string
  default     = "10.30.2.0/24"
}

variable "gateway_subnet_cidr" {
  description = "Gateway for Containers subnet CIDR."
  type        = string
  default     = "10.30.3.0/24"
}

variable "postgres_sku_name" {
  description = "Flexible server SKU name."
  type        = string
  default     = "GP_Standard_D2ds_v4"
}

variable "postgres_version" {
  description = "PostgreSQL version."
  type        = string
  default     = "16"
}

variable "postgres_public_network_access_enabled" {
  description = "Enable public network access for PostgreSQL flexible server. Set false to use private VNet mode."
  type        = bool
  default     = true
}

variable "postgres_active_directory_auth_enabled" {
  description = "Enable Entra (Azure AD) authentication for PostgreSQL flexible server."
  type        = bool
  default     = true
}

variable "postgres_password_auth_enabled" {
  description = "Enable local password authentication for PostgreSQL flexible server."
  type        = bool
  default     = false
}

variable "postgres_entra_tenant_id" {
  description = "Optional Entra tenant ID for PostgreSQL authentication. Defaults to current tenant when null."
  type        = string
  default     = null
}

variable "postgres_entra_admin_object_id" {
  description = "Object ID of Entra principal to assign as PostgreSQL Entra administrator."
  type        = string
  default     = ""
}

variable "postgres_entra_admin_principal_name" {
  description = "Display name of Entra principal for PostgreSQL Entra administrator assignment."
  type        = string
  default     = ""
}

variable "postgres_entra_admin_principal_type" {
  description = "Type of Entra principal for PostgreSQL administrator assignment (Group, User, ServicePrincipal)."
  type        = string
  default     = "Group"

  validation {
    condition     = contains(["Group", "User", "ServicePrincipal"], var.postgres_entra_admin_principal_type)
    error_message = "postgres_entra_admin_principal_type must be Group, User, or ServicePrincipal."
  }
}

variable "postgres_storage_mb" {
  description = "PostgreSQL storage size in MB."
  type        = number
  default     = 65536
}

variable "postgres_database_name" {
  description = "Backstage application database name."
  type        = string
  default     = "backstage"
}

variable "postgres_admin_username" {
  description = "Local admin username for PostgreSQL flexible server."
  type        = string
  default     = "pgadmin"
}

variable "storage_account_tier" {
  description = "Storage account tier."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "storage_account_tier must be Standard or Premium."
  }
}

variable "storage_account_replication_type" {
  description = "Storage replication setting."
  type        = string
  default     = "LRS"

  validation {
    condition     = contains(["LRS", "ZRS", "GRS", "RAGRS", "GZRS", "RAGZRS"], var.storage_account_replication_type)
    error_message = "storage_account_replication_type must be one of LRS, ZRS, GRS, RAGRS, GZRS, RAGZRS."
  }
}

variable "storage_container_name" {
  description = "Blob container used by Backstage."
  type        = string
  default     = "backstage-assets"
}

variable "acr_sku" {
  description = "Azure Container Registry SKU."
  type        = string
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "acr_sku must be Basic, Standard, or Premium."
  }
}

variable "acr_admin_enabled" {
  description = "Enable ACR admin user. Keep false for AKS-managed pulls."
  type        = bool
  default     = false
}

variable "enable_key_vault_for_backstage" {
  description = "Enable Key Vault integration for Backstage secrets."
  type        = bool
  default     = true
}

variable "existing_key_vault_id" {
  description = "Optional existing Key Vault resource ID to use instead of creating one."
  type        = string
  default     = null
}

variable "key_vault_name" {
  description = "Optional custom Key Vault name. When null, a name is generated from the naming prefix."
  type        = string
  default     = null
}

variable "backstage_namespace" {
  description = "Kubernetes namespace where Backstage runs."
  type        = string
  default     = "backstage"
}

variable "backstage_service_account_name" {
  description = "Kubernetes service account used by Backstage deployment."
  type        = string
  default     = "backstage-sa"
}

variable "enable_gateway_for_containers" {
  description = "Toggle deployment of Azure Gateway for Containers resources."
  type        = bool
  default     = true
}

variable "gateway_extension_type" {
  description = "AKS extension type for Gateway for Containers."
  type        = string
  default     = "microsoft.alb"
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
