# How to Discover Unknown Backstage Imports

When you need to find an import for a feature (auth ref, API, component, etc.), use this checklist:

## Quick Discovery Checklist

### 1. **Official Docs** (Start here)
- Go to https://backstage.io/docs/
- Search for the feature (e.g., "microsoft auth", "catalog api")
- Provider docs often show code examples with exact imports

### 2. **TypeScript IntelliSense in VS Code**
- Type the partial symbol in your file: `microsoft` or `AuthApiRef`
- Press `Ctrl+Space` to trigger autocomplete
- Import suggestions appear with module source
- Press `Ctrl+Shift+I` to auto-import selected suggestion

### 3. **Search node_modules** (Most reliable)
```powershell
# Search for a specific ref/export name
rg "microsoftAuthApiRef|githubAuthApiRef" node_modules/@backstage

# Search for all auth refs
rg "AuthApiRef" node_modules/@backstage/core-plugin-api

# Search for exports in a specific package
rg "export.*microsoft" node_modules/@backstage/plugin-auth-backend-module-microsoft-provider
```

### 4. **Check Published Types** (If rg doesn't find it)
- Open node_modules/@backstage/[package-name]/dist/index.d.ts
- Search for the symbol name in the type definitions

### 5. **GitHub Repo Examples** (Complex features)
- Visit https://github.com/backstage/backstage
- Look in examples/ or plugins/ for real code
- Search the repo for your provider name

## Common Patterns

| What You Need | Likely Package | Example |
|---------------|----------------|---------|
| Auth API ref | `@backstage/core-plugin-api` | `microsoftAuthApiRef` |
| Backend auth module | `@backstage/plugin-auth-backend-module-{provider}` | `@backstage/plugin-auth-backend-module-microsoft-provider` |
| Core components | `@backstage/core-components` | `SignInPage` |
| Plugin utilities | `@backstage/frontend-plugin-api` | `createFrontendModule` |

## Why It Matters

- **Docs** = human-friendly starting point
- **IntelliSense** = fastest for exploration (saves typing wrong names)
- **rg search** = finds exactly what's exported (no guessing)
- **GitHub examples** = real working code in context

