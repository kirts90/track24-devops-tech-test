# Kubernetes Deployment with Kustomize

This directory contains Kubernetes manifests for deploying the Track24 API application using Kustomize.

## Structure

```
kustomize/
├── base/             # Base configuration for all environments
└── overlays/         # Environment-specific configurations
    ├── local/        # Local development configuration
    └── production/   # Production configuration
```

## Prerequisites

Before deploying, you need to create the Kubernetes secret containing the Google API key:

### For Local Development

```bash
kubectl create secret generic track24-api-secrets \
  --from-literal=GOOGLE_API_KEY=<your-google-api-key>
```

### For Production

The API key is stored in GitHub Actions Secrets as `GOOGLE_API_KEY` and is applied during the CI/CD workflow.

## Deployment

### Local

```bash
kubectl apply -k kustomize/overlays/local
```

### Production

```bash
kubectl apply -k kustomize/overlays/production
```

## Features

- High availability through multiple replicas
- Horizontal Pod Autoscaling based on CPU utilization (50%)
- Secure handling of sensitive API keys
- Environment-specific configurations
- External traffic exposure through Ingress and Service configurations