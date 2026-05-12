## Key Learnings

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

## Adding plugins

- No key learnings captured yet.

## Customizing Your App's UI

- No key learnings captured yet.

## Populating the homepage

- No key learnings captured yet.
