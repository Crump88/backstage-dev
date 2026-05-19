# ALB-managed Gateway Chart

This chart deploys both:
- an `ApplicationLoadBalancer` custom resource for Azure Application Gateway for Containers in managed-by-ALB mode
- a Gateway API `Gateway` resource in the same infrastructure namespace

## Prerequisites

1. Deploy Terraform from `backstage-infra` with `enable_gateway_for_containers = true`.
2. Install ALB controller Helm chart in AKS (Microsoft chart):

```bash
helm upgrade --install alb-controller oci://mcr.microsoft.com/application-lb/charts/alb-controller \
  --namespace azure-alb-system \
  --create-namespace \
  --version 1.10.27 \
  --set albController.namespace=azure-alb-system \
  --set albController.podIdentity.clientID=<gateway_for_containers_alb_controller_identity_client_id>
```

## Configure values

Set at minimum:

- `alb.associationSubnetId`: from Terraform output `gateway_for_containers_subnet_id`
- `alb.infrastructureNamespace`: namespace to hold ALB infra custom resource
- `alb.name`: ApplicationLoadBalancer resource name
- `gateway.name`: Gateway resource name
- `gateway.className`: GatewayClass name (default `azure-alb-external`)

## Install

```bash
helm upgrade --install alb-managed-gateway ./helm-deploy/alb-managed-gateway \
  --namespace alb-infra \
  --create-namespace \
  --set alb.infrastructureNamespace=alb-infra \
  --set alb.associationSubnetId=<gateway_for_containers_subnet_id>
```

## Verify

```bash
kubectl get applicationloadbalancer -n alb-infra
kubectl get applicationloadbalancer <alb-name> -n alb-infra -o yaml
kubectl get gateway -n alb-infra
kubectl get gateway <gateway-name> -n alb-infra -o yaml
```

When provisioning succeeds, the ALB custom resource status will include accepted and deployment-ready conditions.
