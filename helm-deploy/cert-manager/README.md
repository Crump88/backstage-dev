# cert-manager Helm Chart

This chart wraps the official Jetstack cert-manager chart and installs cert-manager in its own namespace.

## What This Chart Does

- Pulls the official dependency from `https://charts.jetstack.io`
- Installs cert-manager with CRDs enabled
- Supports a dedicated namespace (`cert-manager` by default)

## Prerequisites

- Cluster admin access to install CRDs
- Helm 3+

## Install

From the repository root:

```bash
helm dependency update ./helm-deploy/cert-manager

helm upgrade --install cert-manager ./helm-deploy/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  -f ./helm-deploy/cert-manager/values.yaml
```

## Verify

```bash
kubectl get pods -n cert-manager
kubectl get crds | grep cert-manager
kubectl get validatingwebhookconfigurations | grep cert-manager
```

## Notes

- Best practice is to keep cert-manager in a dedicated namespace.
- If you change `namespace.name`, also install the release with the same `--namespace` value.
