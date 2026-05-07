# Backstage Starter Deep Dive (key files + line-by-line)

This guide explains what your current scaffolded files do and how to safely change them.

## 1) Root package.json (repo commands)

File purpose:
- Defines monorepo scripts and workspace packages.

Key fields and what they mean:
- engines.node: requires Node 22 or 24.
- scripts.start: starts the whole Backstage dev environment.
- scripts.new: scaffolds new Backstage packages/plugins.
- workspaces: packages/* and plugins/* are managed together.
- packageManager: yarn 4.4.1 (use yarn, not npm for normal flow).

Why this matters:
- If scripts fail, this file is the first check.

## 2) app-config.yaml (runtime behavior)

Treat this as your runtime wiring file.

Line-by-line walkthrough (by section):

- app.title / app.baseUrl:
  - Sets browser UI branding and expected frontend URL.
- app.packages: all:
  - Auto-discovers frontend packages from packages/app/package.json.
- app.extensions:
  - Disables specific built-in nav items.
  - Reconfigures catalog page to path /.
- organization.name:
  - Display org name used by some UI surfaces.
- backend.baseUrl / backend.listen.port:
  - Backend service endpoint and port.
- backend.cors:
  - Allows frontend at localhost:3000 to call backend.
- backend.database:
  - better-sqlite3 with :memory: for local ephemeral data.
- backend.actions.pluginSources:
  - Enables action providers used by mcp actions.
- integrations.github:
  - Reads GITHUB_TOKEN for GitHub API calls.
- techdocs:
  - Local builder/generator/publisher setup for local docs.
- auth.providers.guest:
  - Enables no-friction local sign-in.
- catalog.locations:
  - Registers local YAML sources (entities, template, org).
- permission.enabled: true:
  - Permission framework is active.
- mcpActions:
  - App name/description for mcp actions integration.

Safe edits for beginners:
- app.title
- organization.name
- catalog.locations additions
- integrations tokens via environment variables

Higher-risk edits:
- backend.cors
- auth providers for non-local deployments
- database settings

## 3) packages/app/src/index.tsx (frontend boot)

Code flow:
1. Import asset types and styles.
2. Import App object from App.tsx.
3. Create React root from HTML element id root.
4. Render App.createRoot().

Meaning:
- This is the frontend entrypoint; usually unchanged unless bootstrapping custom behavior.

## 4) packages/app/src/App.tsx (frontend app composition)

Current code:
- Imports createApp from frontend defaults.
- Imports catalog plugin.
- Imports custom nav module.
- Exports createApp({ features: [catalogPlugin, navModule] }).

Line-by-line intent:
- createApp: constructs the frontend app shell.
- features array: registers enabled frontend features/modules.

How to extend:
- Add more plugin features to features array.
- Keep imports explicit so it is obvious what is enabled.

## 5) packages/app/src/modules/nav/index.ts (register nav module)

What it does:
- Creates a frontend module for pluginId app.
- Exposes SidebarContent extension.

This file is an adapter: very small, mostly wiring.

## 6) packages/app/src/modules/nav/Sidebar.tsx (custom sidebar logic)

What happens in this file:
- Imports Backstage sidebar UI components.
- Creates SidebarContent extension with NavContentBlueprint.make.
- Converts discovered nav items into SidebarItem components.
- Explicitly removes search page nav item from default nav list.
- Renders:
  - Logo
  - Search group with modal
  - Menu group with catalog + scaffolder + remaining pages
  - Notifications item
  - Settings group with user/settings items

Important line-by-line ideas:
- navItems.withComponent(...): transforms nav metadata into UI links.
- nav.take('page:search'): consumes and suppresses default search nav entry.
- nav.take('page:catalog'): places catalog exactly where you want.
- nav.rest({ sortBy: 'title' }): anything else appears sorted.

How to customize safely:
- Reorder nav.take calls to change menu order.
- Add/remove groups and separators.
- Keep nav.rest to avoid accidentally hiding plugin pages.

## 7) packages/app/src/modules/nav/SidebarLogo.tsx (logo behavior)

What it does:
- Defines styles for logo area dimensions/position.
- Reads sidebar open/closed state.
- Shows full logo when open, icon logo when collapsed.
- Links logo to home path /.

Why this matters:
- This is the clean place to brand the portal visually.

## 8) packages/backend/src/index.ts (backend plugin composition)

Core idea:
- Backend is composed by calling backend.add(import('plugin-or-module')).

What your file currently adds:
- app backend
- proxy backend
- scaffolder backend + github + notifications modules
- techdocs backend
- auth backend + guest module
- catalog backend + scaffolder entity model + logs
- permission backend + allow-all policy
- search backend + pg engine + catalog + techdocs collators
- kubernetes backend
- notifications backend
- signals backend
- mcp actions backend

Line-by-line pattern:
1. create backend object.
2. add plugin modules one by one.
3. call backend.start().

Practical advice:
- If a feature does not appear, confirm plugin is added here and configured in app-config.yaml.

## 9) examples folder (your training ground)

- examples/entities.yaml: sample software entities.
- examples/org.yaml: users/groups.
- examples/template/template.yaml: software template definition.
- examples/template/content: files the template emits.

Best place to learn without heavy coding:
- Create your own entity/template YAML first.

## 10) How to build new things in this starter

Use this low-risk sequence:

1. Model your platform inventory in catalog YAML.
2. Add one scaffolder template for a common service pattern.
3. Add/adjust nav to surface what your org needs first.
4. Add one backend plugin integration only when needed.
5. Add tests for changed behavior.

## 11) Mini project ideas (great first contributions)

- Add "Platform Standards" component/system entities.
- Create template for "Python API service" with CI files.
- Add "Runbooks" TechDocs pages and link to entities.
- Add custom sidebar group for "Internal Tools".

## 12) How to debug when stuck

Checklist:
- Is plugin/module imported in backend index?
- Is config present in app-config.yaml?
- Is env var set (for example GITHUB_TOKEN)?
- Are frontend and backend both running?
- Did you restart after backend/config changes?

Useful commands:

```bash
yarn start
yarn test
yarn lint:all
yarn build:all
```

## 13) Suggested next coding step (hands-on)

Implement this first:
1. Copy one entity from examples/entities.yaml.
2. Rename it to a real internal service.
3. Add owner/system tags meaningful to your org.
4. Confirm it appears in Catalog.

Then implement this second:
1. Duplicate examples/template/template.yaml into a new template file.
2. Change metadata/title/description/parameters for your team.
3. Register the new template in catalog.locations.
4. Run it from Create and verify generated output.
