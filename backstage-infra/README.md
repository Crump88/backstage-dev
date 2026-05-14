# Backstage Azure Infrastructure (Terraform)

This folder contains a modular Terraform implementation for deploying Azure infrastructure for Backstage:

- AKS (public or private API server)
- Azure Database for PostgreSQL Flexible Server
- Azure Storage Account + private blob container
- AKS workload identity for Backstage service account
- Azure Key Vault for Backstage secrets (optional, or reuse existing vault)
- Azure Gateway for Containers (AKS extension + traffic controller)

## Module Layout

- `modules/networking`: resource group, vnet, AKS subnet, PostgreSQL delegated subnet, Gateway for Containers delegated subnet
- `modules/aks`: AKS cluster with OIDC issuer and workload identity enabled
- `modules/postgres`: flexible server + private DNS zone + app database
- `modules/storage`: storage account + blob container
- `modules/workload-identity`: user-assigned managed identity + federated identity credential + blob RBAC
- `modules/key-vault`: key vault with RBAC authorization enabled
- `modules/gateway-for-containers`: AKS extension and traffic controller

## Quick Start

1. Copy values and customize:

   cp terraform.tfvars.example terraform.tfvars

2. Initialize and validate:

   terraform init
   terraform validate

3. Plan and apply:

   terraform plan -out tfplan
   terraform apply tfplan

## Workload Identity Integration (Backstage Helm/K8s)

Annotate the Backstage Kubernetes service account with the managed identity client ID output from Terraform:

- Annotation key: `azure.workload.identity/client-id`
- Value: output `backstage_workload_identity_client_id`

Use matching namespace and service account values from these variables:

- `backstage_namespace`
- `backstage_service_account_name`

If you use Key Vault CSI for Backstage config, this stack also grants the Backstage managed identity `Key Vault Secrets User` on the configured key vault.
You can either create a vault in this stack (`enable_key_vault_for_backstage=true`) or pass an existing one via `existing_key_vault_id`.

Useful outputs for AKS deployment manifests:

- `backstage_workload_identity_client_id`
- `backstage_key_vault_name`
- `postgres_server_fqdn`
- `postgres_database_name`
- `acr_login_server`

## Public vs Private AKS

Switch with variable `aks_private_cluster_enabled`:

- `false`: public API server (current testing default)
- `true`: private API server

When public, optionally restrict ingress to API server with `aks_api_server_authorized_ip_ranges`.

## Notes

- PostgreSQL admin password is generated and marked sensitive in outputs.
- Gateway for Containers API versions can change; keep `azapi` provider and API version in `modules/gateway-for-containers/main.tf` aligned with Azure documentation for your target region/subscription.
