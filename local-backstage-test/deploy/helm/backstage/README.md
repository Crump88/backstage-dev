# Backstage Helm Chart for AKS

This chart deploys Backstage to AKS using:

- Workload identity for pod identity on AKS
- ConfigMap for non-sensitive runtime configuration
- One of two secret patterns:
  - Kubernetes Secret (existing or chart-created)
  - Azure Key Vault via Secrets Store CSI Driver

## Prerequisites

- AKS and supporting resources deployed from `backstage-infra`
- ACR login server output from Terraform (`acr_login_server`)
- Workload identity client ID from Terraform (`backstage_workload_identity_client_id`)
- Key Vault name from Terraform (`backstage_key_vault_name`) when CSI mode is used
- Secrets Store CSI Driver and Azure Key Vault provider installed in AKS for CSI mode

## Build and push image

From `local-backstage-test`:

```bash
docker build -t <acr-login-server>/backstage:<tag> .
az acr login --name <acr-name>
docker push <acr-login-server>/backstage:<tag>
```

## Configure values

Edit `values.yaml` or provide `-f values-<env>.yaml`.

At minimum set:

- `image.repository`
- `image.tag`
- `serviceAccount.annotations.azure.workload.identity/client-id`
- `config.APP_BASE_URL`
- `config.BACKEND_BASE_URL`
- `config.CORS_ORIGIN`
- `config.POSTGRES_HOST`
- `config.POSTGRES_USER`
- `config.POSTGRES_DATABASE`
- `config.MICROSOFT_TENANT_ID`
- `config.AZURE_CLIENT_ID`
- `config.AZURE_TENANT_ID`

## Option A: Kubernetes Secret + ConfigMap

Use an existing secret:

```yaml
secrets:
  existingSecretName: backstage-secrets
  create: false

keyVaultCSI:
  enabled: false
```

Or let chart create secret from values (not recommended for production repos):

```yaml
secrets:
  create: true
  data:
    POSTGRES_PASSWORD: "..."
    MICROSOFT_CLIENT_ID: "..."
    MICROSOFT_CLIENT_SECRET: "..."
    GITHUB_TOKEN: "..."
```

Install/upgrade:

```bash
helm upgrade --install backstage ./deploy/helm/backstage \
  --namespace backstage \
  --create-namespace \
  -f ./deploy/helm/backstage/values.yaml
```

## Option B: Key Vault CSI + Workload Identity

Enable CSI and set Key Vault values:

```yaml
keyVaultCSI:
  enabled: true
  clientId: "<workload-identity-client-id>"
  keyVaultName: "<key-vault-name>"
  tenantId: "<tenant-id>"

secrets:
  name: backstage-secrets
  create: false
  existingSecretName: ""
```

Create these Key Vault secret names:

- `postgres-password`
- `microsoft-client-id`
- `microsoft-client-secret`
- `github-token`
- `gh-auth-org-client-secret`
- `gh-auth-org-webhook-secret`
- `gh-auth-org-private-key`
- `backstage-backend-secret`

Install/upgrade:

```bash
helm upgrade --install backstage ./deploy/helm/backstage \
  --namespace backstage \
  --create-namespace \
  -f ./deploy/helm/backstage/values.yaml
```

When CSI mode is enabled, the chart creates a `SecretProviderClass` and syncs Key Vault values into the Kubernetes Secret used by Backstage.
