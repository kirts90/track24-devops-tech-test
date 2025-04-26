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
   *(To be implemented)*

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

### Checklist before requesting a review

- [ ] I have performed a self-review of my code.
- [ ] I have included any documentation relevant to review my changes.
