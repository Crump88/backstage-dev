# Backstage on Azure — Learning Path

> **Greenfield deployment · 2-week aggressive track**  
> Backstage 1.x · Azure ecosystem · ~6–8 hrs/day

---

## Overview

This path takes you from Backstage consumer to deployer/developer in 10 focused days. Week 1 builds core competency with a local running instance. Week 2 wires in the Azure integrations that matter for a real enterprise deployment and gets you to production on AKS.

### Key Azure integrations covered
- **Azure DevOps** — catalog auto-discovery, pipeline cards, `publish:azure` scaffolder action
- **Azure Entra ID (AAD)** — enterprise SSO + org sync via Microsoft Graph
- **Azure Blob Storage** — TechDocs external publisher
- **Azure Kubernetes Service (AKS)** — production deployment with Workload Identity
- **Azure Container Registry (ACR)** — image publishing via ADO pipelines
- **Azure Key Vault** — secrets management via CSI driver / External Secrets
- **Azure Monitor / Application Insights** — observability and alerting
- **Azure Database for PostgreSQL Flexible Server** — production catalog backend

---

## Week 1 — Foundations & Core

### Day 1 — Architecture deep-dive
> Understand Backstage's mental model before touching code

**Tasks**
- [ ] Read the official "What is Backstage?" overview and the Software Catalog architecture docs in full
- [ ] Study the three pillars: Software Catalog, TechDocs, and the Plugin system
- [ ] Watch the official KubeCon/BackstageCon talk: "Backstage and the Power of the Developer Portal"
- [ ] Diagram (on paper) how entities relate: `Component → System → Domain → Resource → API`
- [ ] Set up a private GitHub/ADO repo to track your notes and YAML experiments

**Resources**
- [Backstage documentation home](https://backstage.io/docs)
- [What is Backstage? (blog)](https://backstage.io/blog/2020/03/18/what-is-backstage)
- [Spotify Backstage Overview — YouTube (official)](https://www.youtube.com/watch?v=85TQEpNCaU0)
- [BackstageCon talks playlist](https://www.youtube.com/@BackstageCon)

---

### Day 2 — Local dev environment
> Get Backstage running locally end-to-end

**Tasks**
- [ ] Install prerequisites: Node 18 LTS, Yarn, Docker Desktop
- [ ] Scaffold a new app via `npx @backstage/create-app@latest` and walk through every generated file
- [ ] Understand the monorepo structure: `packages/app` (frontend), `packages/backend`
- [ ] Explore `app-config.yaml` — understand auth, catalog, integrations, and proxy sections
- [ ] Register your first entity manually via the UI and inspect the catalog API response in dev tools

**Resources**
- [Getting started — create your Backstage app](https://backstage.io/docs/getting-started)
- [Writing configuration — app-config.yaml reference](https://backstage.io/docs/conf/writing)

---

### Day 3 — Software Catalog mastery
> The heart of every Backstage deployment

**Tasks**
- [ ] Write `catalog-info.yaml` files for 3–5 mock services covering `Component`, `API`, and `System` kinds
- [ ] Configure a static file location provider in `app-config.yaml`
- [ ] Understand all entity annotation fields: `backstage.io/techdocs-ref`, `github.com/project-slug`, etc.
- [ ] Explore catalog filters, label selectors, and relations in the catalog API
- [ ] Write a custom entity processor (even trivial) to understand the ingestion pipeline

**Resources**
- [Software Catalog overview](https://backstage.io/docs/features/software-catalog)
- [Entity descriptor format reference](https://backstage.io/docs/features/software-catalog/descriptor-format)
- [Well-known annotations](https://backstage.io/docs/features/software-catalog/well-known-annotations)
- [Entity relations](https://backstage.io/docs/features/software-catalog/well-known-relations)

> **🔷 Azure note:** Azure DevOps repos will serve as your primary catalog source. Plan to use the ADO integration to auto-discover repos by scanning Azure organizations. Every service repo should have a `catalog-info.yaml` committed to it — start this practice now.

---

### Day 4 — Plugin system & frontend
> Understand how the UI is composed

**Tasks**
- [ ] Read the Plugin architecture docs: frontend plugins, backend plugins, and isomorphic plugins
- [ ] Install 2–3 community plugins (e.g., GitHub Actions, cost-insights stub) to see how they integrate
- [ ] Understand `App.tsx` routing and how to mount plugin pages and entity tabs
- [ ] Trace how a plugin's `EntityCard` renders on a catalog entity page — understand plugin extension points
- [ ] Build a trivial "Hello World" frontend plugin from scratch using `backstage-cli plugin:create`

**Resources**
- [Creating a plugin](https://backstage.io/docs/plugins/create-a-plugin)
- [Composability system](https://backstage.io/docs/plugins/composability)
- [Community plugin directory](https://backstage.io/plugins)
- [Backstage plugins source (GitHub)](https://github.com/backstage/backstage/tree/master/plugins)

---

### Day 5 — Azure DevOps integration ⚡
> Connect catalog discovery to your ADO organization

**Tasks**
- [ ] Create an Azure DevOps Personal Access Token (PAT) with Code (read) and Project/Team (read) scopes
- [ ] Configure the `@backstage/plugin-azure-devops-backend` and `@backstage/plugin-azure-devops` packages
- [ ] Set up the ADO catalog provider to auto-ingest all repos with a `catalog-info.yaml` from your ADO org
- [ ] Verify pull request annotations surface on entity pages using the Azure DevOps plugin UI card
- [ ] Explore the ADO Pipelines card: wire up a sample pipeline and confirm build status appears in Backstage

**Resources**
- [Azure DevOps locations integration](https://backstage.io/docs/integrations/azure/locations)
- [Azure DevOps discovery provider](https://backstage.io/docs/integrations/azure/discovery)
- [azure-devops plugin source (GitHub)](https://github.com/backstage/backstage/tree/master/plugins/azure-devops)
- [ADO PAT scopes reference](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate)

> **🔷 Azure note:** This is the highest-priority integration for an Azure-first client. The ADO provider replaces manual `catalog-info.yaml` registration — it scans your entire Azure DevOps organization automatically. Set `catalogPath: "/**catalog-info.yaml"` to catch nested monorepos.

---

## Week 2 — Azure Integrations & Deploy

### Day 6 — Azure AD / Entra ID auth ⚡
> Enterprise SSO — the non-negotiable for any real deployment

**Tasks**
- [ ] Register a new App Registration in Azure Entra ID (formerly Azure AD) with appropriate redirect URIs
- [ ] Configure the `@backstage/plugin-auth-backend-module-microsoft-provider` module
- [ ] Set up sign-in resolvers: map AAD UPN to a Backstage User entity
- [ ] Integrate group membership sync from Azure AD — use `MicrosoftGraphOrgEntityProvider` to auto-populate User and Group entities
- [ ] Test guest/member flows and understand token TTL, refresh behavior, and session storage

**Resources**
- [Microsoft auth provider — Backstage docs](https://backstage.io/docs/auth/microsoft/provider)
- [Azure AD org integration (Microsoft Graph)](https://backstage.io/docs/integrations/azure/org)
- [Register an app in Azure Entra ID](https://learn.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)
- [Microsoft Graph permissions reference](https://learn.microsoft.com/en-us/graph/permissions-reference)

> **🔷 Azure note:** `MicrosoftGraphOrgEntityProvider` is your org chart source of truth. It syncs Azure AD users and security groups as Backstage `User`/`Group` entities on a schedule. Combined with AAD sign-in, every user's team memberships and ownership relationships are automatic — no manual maintenance.

---

### Day 7 — TechDocs & Azure Blob Storage
> Documentation-as-code backed by Azure storage

**Tasks**
- [ ] Configure TechDocs in "external" generation mode (not "local") for production readiness
- [ ] Set up an Azure Blob Storage container as the TechDocs publisher target
- [ ] Write an ADO pipeline that runs `techdocs-cli generate` and `techdocs-cli publish --publisher-type azureBlobStorage`
- [ ] Add `backstage.io/techdocs-ref: dir:.` to a catalog entity and verify docs render in Backstage
- [ ] Configure a custom MkDocs theme if required; understand the `mkdocs.yml` schema

**Resources**
- [TechDocs getting started](https://backstage.io/docs/features/techdocs/getting-started)
- [Using cloud storage with TechDocs](https://backstage.io/docs/features/techdocs/using-cloud-storage)
- [TechDocs CLI reference](https://backstage.io/docs/features/techdocs/cli)
- [Azure Blob Storage documentation](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction)
- [MkDocs configuration reference](https://www.mkdocs.org/user-guide/configuration/)

> **🔷 Azure note:** Use an Azure Blob Storage container with a **private** access tier — Backstage's backend proxies doc reads, so public blobs are not required. Assign the `Storage Blob Data Contributor` role to your ADO pipeline's service connection identity.

---

### Day 8 — Azure Container Registry & Software Templates
> Scaffolding golden paths with ACR and ADO pipelines

**Tasks**
- [ ] Build a Software Template that scaffolds a new Node.js or .NET service with a Dockerfile and ADO pipeline YAML
- [ ] Understand the Scaffolder backend and how actions (`fetch:template`, `publish:azure`, `catalog:register`) chain together
- [ ] Configure the `publish:azure` scaffolder action to create repos in an ADO project automatically
- [ ] Add a step to trigger an initial ADO pipeline run post-scaffold
- [ ] Explore custom Scaffolder actions: write one action that creates an Azure Resource Group via the Azure SDK

**Resources**
- [Software Templates overview](https://backstage.io/docs/features/software-templates)
- [Built-in scaffolder actions](https://backstage.io/docs/features/software-templates/builtin-actions)
- [Writing custom scaffolder actions](https://backstage.io/docs/features/software-templates/writing-custom-actions)
- [Template YAML syntax reference](https://backstage.io/docs/features/software-templates/writing-templates)
- [Azure SDK for JavaScript](https://learn.microsoft.com/en-us/azure/developer/javascript/sdk/azure-sdk-overview)

> **🔷 Azure note:** The `publish:azure` action uses the same ADO PAT or service principal configured in your integration settings. For golden-path templates, also consider auto-linking the new repo to an Azure Pipeline template from your central `.azuredevops/` repo to enforce organizational standards from day one.

---

### Day 9 — Azure Kubernetes Service & production deployment ⚡
> Run Backstage itself on AKS with production config

**Tasks**
- [ ] Containerize the Backstage app: write a production Dockerfile (multi-stage, non-root user)
- [ ] Push to Azure Container Registry via an ADO pipeline with service connection authentication
- [ ] Write Kubernetes manifests: `Deployment`, `Service`, `HorizontalPodAutoscaler`, and `ConfigMap` for app-config
- [ ] Store secrets (PATs, client secrets, DB passwords) in Azure Key Vault and inject via the CSI driver or Kubernetes ExternalSecrets operator
- [ ] Configure a PostgreSQL backend (Azure Database for PostgreSQL Flexible Server) and wire Backstage's backend to it
- [ ] Deploy to AKS and verify all plugins and catalog ingestion work in the cluster

**Resources**
- [Deploying Backstage to Kubernetes](https://backstage.io/docs/deployment/k8s)
- [Docker deployment guide](https://backstage.io/docs/tutorials/docker)
- [AKS quickstart — deploy an application](https://learn.microsoft.com/en-us/azure/aks/tutorial-kubernetes-deploy-application)
- [Azure Key Vault CSI driver](https://learn.microsoft.com/en-us/azure/aks/csi-secrets-store-driver)
- [AKS Workload Identity](https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview)
- [Azure Database for PostgreSQL Flexible Server](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/overview)
- [External Secrets Operator](https://external-secrets.io/latest/provider/azure-key-vault/)

> **🔷 Azure note:** Use **Azure Managed Identity (Workload Identity)** assigned to the Backstage pod instead of storing client secrets in environment variables. This lets your Backstage backend authenticate to Azure Key Vault, ADO, and ACR without any long-lived credential in the cluster.

---

### Day 10 — Azure Monitor, Application Insights & hardening
> Observability, RBAC, and production readiness

**Tasks**
- [ ] Instrument the Backstage backend with Application Insights using the Node.js SDK or OpenTelemetry Azure exporter
- [ ] Set up Azure Monitor alerts for pod restarts, catalog sync failures, and auth errors
- [ ] Implement Backstage's built-in RBAC (permissions framework): define policies for who can edit/delete catalog entities
- [ ] Configure the `@backstage/plugin-permission-backend` and wire a custom permission policy for your client's org structure
- [ ] Perform a security review: rotate all PATs to short-lived tokens, enable Azure AD Conditional Access for the app registration, review CORS and CSP headers
- [ ] Write a runbook: catalog re-sync procedure, AKS upgrade steps, TechDocs rebuild trigger

**Resources**
- [Backstage permissions overview](https://backstage.io/docs/permissions/overview)
- [Writing a permission policy](https://backstage.io/docs/permissions/writing-a-policy)
- [Application Insights — Node.js](https://learn.microsoft.com/en-us/azure/azure-monitor/app/nodejs)
- [OpenTelemetry Azure Monitor exporter](https://learn.microsoft.com/en-us/azure/azure-monitor/app/opentelemetry-enable?tabs=nodejs)
- [Azure Monitor alerts](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview)
- [Azure AD Conditional Access](https://learn.microsoft.com/en-us/azure/active-directory/conditional-access/overview)

> **🔷 Azure note:** Wire Application Insights using the **connection string** (not the instrumentation key — it's deprecated). For RBAC, map Backstage permission conditions to Azure AD group membership from the synced `Group` entities so team leads automatically get edit rights over their own services.

---

## Azure Integration Reference

| Integration | Package(s) | Priority | Day |
|---|---|---|---|
| Azure DevOps catalog discovery | `@backstage/plugin-azure-devops-backend` | 🔴 Critical | 5 |
| Azure DevOps UI (PRs, pipelines) | `@backstage/plugin-azure-devops` | 🔴 Critical | 5 |
| Azure Entra ID (AAD) auth | `@backstage/plugin-auth-backend-module-microsoft-provider` | 🔴 Critical | 6 |
| Microsoft Graph org sync | `@backstage/plugin-catalog-backend-module-msgraph` | 🔴 Critical | 6 |
| TechDocs — Azure Blob publisher | `@backstage/plugin-techdocs-backend` (built-in) | 🟠 High | 7 |
| Scaffolder — publish to ADO | `@backstage/plugin-scaffolder-backend-module-azure` | 🟠 High | 8 |
| Backstage permissions / RBAC | `@backstage/plugin-permission-backend` | 🟠 High | 10 |
| Application Insights / OTel | `applicationinsights` / `@azure/monitor-opentelemetry` | 🟡 Medium | 10 |

---

## Recommended additional resources

- [Backstage community Discord](https://discord.gg/backstage-687207715902193673)
- [Backstage GitHub — issues & discussions](https://github.com/backstage/backstage)
- [CNCF Backstage project page](https://www.cncf.io/projects/backstage/)
- [backstage-community/community-plugins (GitHub)](https://github.com/backstage/community-plugins)
- [Roadie.io blog — Backstage tutorials](https://roadie.io/blog/) *(third-party, high quality)*
- [Azure Architecture Center — AKS best practices](https://learn.microsoft.com/en-us/azure/aks/best-practices)
- [Microsoft identity platform docs](https://learn.microsoft.com/en-us/azure/active-directory/develop/)

---

*Generated for a greenfield Backstage deployment in an Azure ecosystem. Adjust daily pacing based on your team's existing familiarity with Kubernetes and Azure IAM.*
