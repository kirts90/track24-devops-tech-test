# Terraform Deployment for Track24 API

This directory contains Terraform configurations to deploy the Track24 API to Kubernetes clusters, supporting both local development and production environments.

## Directory Structure

```
terraform/
├── envs/                     # Environment-specific configurations
│   ├── local/                # Local development environment
│   └── production/           # Production environment
└── modules/                  # Reusable Terraform modules
    └── kubernetes/           # Kubernetes deployment module
```

## Prerequisites

- Terraform 1.0+
- kubectl and a configured Kubernetes cluster
- FluxCD installed in the cluster (required for GitOps deployment)
- For local: Docker Desktop with Kubernetes enabled
- For production: AWS credentials and access to an EKS cluster

## Module: Kubernetes

The Kubernetes module provides a flexible way to deploy the Track24 API to any Kubernetes cluster. It supports:

- Deployment with multiple replicas for high availability
- Secret management for sensitive values like API keys
- Horizontal Pod Autoscaling
- Service exposure via different service types
- Two deployment methods:
  1. Direct deployment with Terraform-managed resources
  2. GitOps deployment using Kustomize and FluxCD (when use_kustomize = true)

## Local Development Environment

The local environment is configured to work with Docker Desktop's Kubernetes.

### Setup and Deploy

1. Create a tfvars file from the example:
   ```bash
   cd terraform/envs/local
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit the terraform.tfvars file to set configuration values. The Google API key is optional if you've already created the Kubernetes secret.

3. Initialize and apply:
   ```bash
   terraform init
   terraform apply
   ```

## Production Environment

The production environment is configured for AWS EKS.

### Setup and Deploy

1. Create a tfvars file from the example:
   ```bash
   cd terraform/envs/production
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit the terraform.tfvars file to set:
   - eks_cluster_name
   - git_repository_url
   - The Google API key is optional if you've already created the Kubernetes secret in the cluster

3. Configure the S3 backend:
   ```bash
   terraform init \
     -backend-config="bucket=your-terraform-state-bucket" \
     -backend-config="key=track24-api/production/terraform.tfstate" \
     -backend-config="region=eu-west-2"
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

## Environment-Specific Variables

Different environments can be customized with different values for:

- Resource requests/limits
- Number of replicas
- Auto-scaling parameters
- Service types
- Container image sources

## Using Kustomize Integration

The Terraform configuration can deploy resources in two ways:

1. **Direct deployment** (use_kustomize = false): Terraform directly creates all Kubernetes resources
2. **Kustomize deployment** (use_kustomize = true): Terraform sets up FluxCD components to apply Kustomize manifests from a Git repository

The Kustomize approach follows GitOps principles and allows for more declarative management of Kubernetes resources.

### Installing FluxCD

FluxCD is required for the GitOps deployment method. You can install it with:

```bash
# Using kubectl to install FluxCD CRDs and controllers
kubectl apply -f https://github.com/fluxcd/flux2/releases/latest/download/install.yaml

# Or using Flux CLI (if you have admin access to install CLI tools)
curl -s https://fluxcd.io/install.sh | sudo bash
flux install
```

### Using Existing Kubernetes Secrets

If you've already created the Kubernetes secret for the Google API key, you can leave the `google_api_key` field empty in your `terraform.tfvars` file:

```bash
# Create the secret manually (needs to be done only once per environment)
kubectl create secret generic track24-api-secrets --from-literal=GOOGLE_API_KEY=<your-api-key>
```

The Terraform configuration will automatically detect and use this existing secret.