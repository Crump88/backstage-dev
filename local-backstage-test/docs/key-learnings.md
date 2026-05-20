# Backstage Key Learnings

## Setting up authentication

Current focus: Azure Entra authentication.

- Before any user can authenticate into Backstage, they must have a registered user in the Backstage catalog. In an Enterprise setting, this would be done by configuring a catalog synchronization with their Identity Provider (This uses MS Entra)
- Two specific plug-ins are required:
  - [Microsoft auth provider](https://backstage.io/docs/getting-started/config/authentication) for authentication/sign-in.
  - [Microsoft Graph](https://backstage.io/docs/integrations/azure/org/) (`msgraph`) provider for catalog synchronization.
- Ensure catalog rules allow the entity kinds you need (for example `User` and `Group`) in `catalog.rules.allow` in [app-config.yaml](../app-config.yaml).
- Configure both application layers:
  - Backend: provider and Graph integration config in [packages\backend\src\index.ts](../packages/backend/src/index.ts)
```yaml
  // auth plugin
backend.add(import('@backstage/plugin-auth-backend'));
backend.add(import('@backstage/plugin-auth-backend-module-microsoft-provider'));
backend.add(import('@backstage/plugin-catalog-backend-module-msgraph'));
```
  - Frontend: [sign-in page](https://backstage.io/docs/getting-started/config/authentication#add-sign-in-option-to-the-frontend)/provider wiring.


## Configuring a database

- Validate Client/Server versions. A mismatch of these will lead to errors/unexpected output for common psql commands.
- Make your account the 
- The app-config definition for postgres in a container is extremely specific. The environment variables will be pulled from the helm chart values on deploy.
  - Specifically, type must be azure, tokenCredential must specificy only clientId (not tenant or secret). This forces it to use the workload identity in Kubernetes (or workload identity on a different compute platform)
```yaml
  database:
    client: pg
    pluginDivisionMode: schema
    ensureExists: false
    ensureSchemaExists: true
    connection:
      type: azure
      tokenCredential:
        tokenRenewableOffsetTime: 5 minutes
        clientId: ${AZURE_CLIENT_ID}
      host: ${POSTGRES_HOST}
      port: ${POSTGRES_PORT}
      database: ${POSTGRES_DATABASE}
      user: ${POSTGRES_USER}
      ssl:
        rejectUnauthorized: true
```

## Adding plugins

- I implemeneted Github integrations specifically for creating Software templates to tokenize a repository.
  - Double check permissions. Github/Backstage has a manifest that can be used to create a Github App, but the permissions were wrong (wasn't able to create repository, read commits, etc)
  - I set the permissions on my Github App to:
    - Repo Permissions:
      - Administration: Read and Write
      - Checks: Read-Only
      - Commit Statuses: Read-Only
      - Contents: Read and Write
      - Metadata: Mandatory Read-Only
    - Org Permissions:
      - Members: Read-Only
- Once I containerized Backstage, I ran into additional issues with this integration, specifically the private key.
  - You have to ensure that you remove Carriage Returns or literal backslash-n sequences.
  - You also need to ensure that they secret is uploaded to keyvault with a content type of `application/x-pem-file`
  
## Customizing Your App's UI

- No key learnings captured yet.

## Populating the homepage

- No key learnings captured yet.

# Infrastructure Key Learnings

## AKS Setup

We've proposed using Azure Gateway For Containers to manage Ingress via the Gateway API
- This feature is both GA and Public Preview (as it has a breadth of services)
- Getting it configured through Terraform has been tricky as the preview features are not yet available as attributes. I had to deploy the cluster, then execute AZ CLI commands.
- This document is a good starting point once the cluster is deployed. [Deploy Application Gateway for Containers](https://learn.microsoft.com/en-us/azure/application-gateway/for-containers/quickstart-deploy-application-gateway-for-containers-alb-controller-addon?tabs=azure-cli%2Cazure-cli2)
  - To start, ensure you've added both the extensions (alb and aks-preview) and the additional features (ManagedGatewayAPIPreview and ApplicationLoadBalancerPreview)
  - Then update the aks cluster through the cli with `az aks create --resource-group $RESOURCE_GROUP --name $AKS_NAME --enable-gateway-api --enable-application-load-balancer`
- I next ran into an issue with permissions on the service account / managed identity. The terraform module created an identity, but AKS created its own it appears.
  - so far - i've manually updated the permissions so that the aks generated service principal (will be in the "MC-" resource group) named `applicationloadbalancer-<aks_cluster_name>` has `network contributor` over the subnet created for gateway for containers by terraform.
- If this is private only, Azure Gateway For Containers does not support [Private IPs](https://learn.microsoft.com/en-us/azure/application-gateway/for-containers/application-gateway-for-containers-components#application-gateway-for-containers-frontends)