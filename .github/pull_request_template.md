### Describe your changes

1. Docker
   - Created production-ready multi-stage Dockerfile in app/ directory
   - Optimized for minimal image size (using Alpine for build, slim for runtime)
   - Implemented security best practices (non-root user, vulnerability scanning)
   - Fixed TypeScript path aliases for proper runtime resolution
   - Implemented efficient Docker layer caching by strategic file copying
   - Created separate development Dockerfile (app/Dockerfile.dev) with hot-reloading
   - Made both environments easily runnable with clear documentation

2. CI
   - Implemented GitHub Actions workflow in `.github/workflows/publish.yml`
   - Configured to trigger on push to main branch
   - Set up Docker layer caching to minimize build times
   - Configured AWS credentials and ECR login
   - Added feature to idempotently create ECR repository if not exists
   - Implemented tagging with both :latest and :commit-sha for traceability

3. Kubernetes
   - Implemented Kubernetes resources using Kustomize with base/overlay structure
   - Created base configurations for Deployment, Service, Ingress, and HPA
   - Set up local and production overlays with environment-specific configurations
   - Securely managed GOOGLE_KEY as Kubernetes Secret
   - Configured environment variables (APP_PORT, GOOGLE_KEY, NODE_ENV)
   - Ensured high availability with multiple replicas (2 base, 3 prod) and rolling updates
   - Implemented HPA based on 50% CPU utilization for auto-scaling
   - Exposed service via NodePort (local) and LoadBalancer with NLB (production)

4. Terraform
   - Implemented modular Terraform configuration for Kubernetes deployments
   - Created environment-specific configurations for local and production
   - Configured Terraform to work with both local Kubernetes and remote EKS clusters
   - Added support for GitOps deployment using Kustomize and FluxCD
   - Set up FluxCD components to automatically sync from Git repository
   - Integrated with existing Kubernetes secrets
   - Implemented dynamic resource allocation based on environment
   - Configured backend storage for state management
   - Added comprehensive documentation for deployment processes

### Document any other steps we need to follow

**Prerequisites & Dependencies**
```bash
# Runtime dependencies with version management via asdf
# Install asdf - https://asdf-vm.com/guide/getting-started.html
# Add plugins and install required versions
asdf plugin add nodejs
asdf plugin add kustomize
asdf plugin add terraform
asdf plugin add kubectl
asdf install nodejs 21.6.0
asdf install kustomize 5.6.0
asdf install terraform 1.5.0  # Recommended minimum version
asdf install kubectl 1.27.3   # Recommended minimum version

# Install FluxCD (required for GitOps deployment with Terraform)
# Option 1: Using kubectl to install FluxCD CRDs and controllers
kubectl apply -f https://github.com/fluxcd/flux2/releases/latest/download/install.yaml

# Option 2: Using Flux CLI (if you have admin access to install CLI tools)
curl -s https://fluxcd.io/install.sh | sudo bash
flux install
```

**Building & Running Production Image**
```bash
# Build production image
docker build -t my-api:prod -f app/Dockerfile .

# Run production image
docker run --rm -p 3000:3000 -e APP_PORT=3000 my-api:prod
```

**Building & Running Development Image**
```bash
# Build development image
docker build -t my-api:dev -f app/Dockerfile.dev .

# Run development image with hot-reloading
docker run --rm -p 3001:3000 -e NODE_ENV=development -e APP_PORT=3000 \
  -v $(pwd)/app/src:/app/src -v $(pwd)/app/config:/app/config my-api:dev
```

**CI/CD Setup Requirements**
```bash
# Required GitHub repository secrets
AWS_ROLE_ARN - IAM role ARN with ECR permissions
GOOGLE_API_KEY - Google API key for geocoding service (used in CI/CD pipeline)

# The workflow will:
# 1. Build the Docker image from app/Dockerfile
# 2. Push to ECR with tags :latest and :{commit-sha}
# 3. Create ECR repository if it doesn't exist
```

**Kubernetes Deployment**
```bash
# Create Google API key secret (needs to be done only once per environment)
kubectl create secret generic track24-api-secrets --from-literal=GOOGLE_API_KEY=<your-api-key>

# Option 1: Direct deployment with kubectl
# Deploy to local Kubernetes
kubectl apply -k kustomize/overlays/local
# Deploy to production Kubernetes
kubectl apply -k kustomize/overlays/production

# Option 2: Terraform-managed deployment (recommended)
# See Terraform Deployment section below - this handles both FluxCD setup and Kubernetes resources
```

**Terraform Deployment**
```bash
# Local deployment
cd terraform/envs/local
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars if needed - Google API key field is optional if the secret already exists in the cluster
terraform init
terraform apply

# Production deployment
cd terraform/envs/production
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars to set your configuration - Google API key field is optional if the secret already exists in the cluster
terraform init \
  -backend-config="bucket=your-terraform-state-bucket" \
  -backend-config="key=track24-api/terraform.tfstate" \
  -backend-config="region=eu-west-2"
terraform apply
```

### Checklist before requesting a review

- [X] I have performed a self-review of my code.
- [X] I have included any documentation relevant to review my changes.
