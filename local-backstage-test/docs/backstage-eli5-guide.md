# Backstage ELI5 Guide (for scripting and Terraform folks)

This guide explains your local Backstage starter app in simple terms.

If you know PowerShell/Python/Terraform, think of Backstage like this:
- Terraform: defines cloud resources.
- Backstage Catalog: defines software resources (services, APIs, systems, teams) as YAML.
- Backstage Scaffolder: like a repo/project generator pipeline.
- Backstage plugins: like modules/providers that add capabilities.
- app-config.yaml: like your central variables + feature wiring file.

## 1) Mental model in 60 seconds

Your app is two apps running together:
- Frontend (web UI): runs on http://localhost:3000
- Backend (API + plugin services): runs on http://localhost:7007

The frontend asks the backend for data/actions. Most Backstage features are plugins that run in one or both.

## 2) Folder map (what matters first)

- package.json (repo root): top-level scripts (start, test, build)
- app-config.yaml: main local runtime config
- packages/app: frontend code
- packages/backend: backend code
- examples: sample catalog entities and templates

## 3) Day-1 commands

From local-backstage-test:

```bash
yarn install
yarn start
```

Useful scripts from root package.json:
- yarn start: start frontend + backend in dev mode
- yarn test: run tests
- yarn lint: lint changed files
- yarn build:all: build everything
- yarn new: generate new Backstage plugin/package scaffold

## 4) What app-config.yaml does (plain English)

Think of app-config.yaml as your "control plane".

Major sections:
- app: app title, UI URL, which frontend extensions/pages are enabled
- backend: backend URL/port, CORS, local DB, backend action sources
- integrations.github: GitHub PAT/token for API access
- auth.providers: who can sign in (guest enabled right now)
- catalog.locations: where Backstage reads entity/template YAML
- techdocs: docs generation/publishing mode
- permission.enabled: turns permission framework on/off

Important local defaults in this starter:
- SQLite in-memory DB (data resets on restart)
- guest auth is on
- catalog reads local files from examples/

## 5) How this starter app is customized already

This scaffold already changed nav behavior:
- Some default nav items are disabled in app-config.yaml extensions
- The Catalog page is remapped to / (root path)
- A custom sidebar module is used from packages/app/src/modules/nav

So if the menu looks different from docs/screenshots, that is expected.

## 6) Key development workflows

### A) Add catalog entities (fastest real value)

1. Add or edit YAML in examples/entities.yaml or your own file.
2. Add the file path under catalog.locations in app-config.yaml.
3. Restart (or refresh) and check Catalog in UI.

This is the lowest-friction way to start building value in Backstage.

### B) Add a software template (Scaffolder)

1. Create a template YAML (see examples/template/template.yaml).
2. Add template content files under a folder.
3. Register template in catalog locations.
4. Open Create in Backstage and run the template.

### C) Add frontend UI behavior

1. Edit packages/app/src/App.tsx to add/remove features.
2. Edit nav module files in packages/app/src/modules/nav.
3. Save and let dev server hot-reload.

### D) Add backend capability

1. Add plugin/module import in packages/backend/src/index.ts.
2. Configure plugin in app-config.yaml.
3. Restart backend.

## 7) Terraform-style mapping to Backstage concepts

- Terraform module = Backstage plugin or frontend module
- Terraform state/resource graph = Backstage Catalog entity graph
- terraform.tfvars = app-config.yaml and env vars
- terraform apply pipeline = Scaffolder template execution
- cloud inventory = Software Catalog

## 8) First practical learning path (no heavy coding)

1. Change app title in app-config.yaml and restart.
2. Add one Component YAML and one API YAML to the catalog.
3. Add one template and run it from Create.
4. Change sidebar labels/order in packages/app/src/modules/nav/Sidebar.tsx.
5. Enable GitHub integration using a PAT in env var and test entity import.

## 9) Common beginner gotchas

- "Why did my data disappear?": local DB is in-memory.
- "Why can everyone log in?": guest auth is enabled for local use.
- "Why is / the catalog page?": page path was remapped in config.
- "Why can’t backend call service": check backend CORS/proxy/integration config.
- "Why no GitHub data": missing GITHUB_TOKEN env var.

## 10) Suggested next step

After this doc, read docs/backstage-key-files-deep-dive.md for file-by-file and line-by-line explanations of your starter code.
