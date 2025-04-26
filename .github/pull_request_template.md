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
   *(To be implemented)*

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

# The workflow will:
# 1. Build the Docker image from app/Dockerfile
# 2. Push to ECR with tags :latest and :{commit-sha}
# 3. Create ECR repository if it doesn't exist
```

### Checklist before requesting a review

- [ ] I have performed a self-review of my code.
- [ ] I have included any documentation relevant to review my changes.
