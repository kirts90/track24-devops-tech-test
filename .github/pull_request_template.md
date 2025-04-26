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

4. Deployment
   *(To be implemented)*

### Document any other steps we need to follow

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
GOOGLE_API_KEY - Google API key for geocoding service

# The workflow will:
# 1. Build the Docker image from app/Dockerfile
# 2. Push to ECR with tags :latest and :{commit-sha}
# 3. Create ECR repository if it doesn't exist
```

**Kubernetes Deployment**
```bash
# Create Google API key secret for local deployment
kubectl create secret generic track24-api-secrets --from-literal=GOOGLE_API_KEY=<your-api-key>

# Deploy to local Kubernetes
kubectl apply -k kustomize/overlays/local

# Deploy to production Kubernetes
kubectl apply -k kustomize/overlays/production
```

### Checklist before requesting a review

- [ ] I have performed a self-review of my code.
- [ ] I have included any documentation relevant to review my changes.
