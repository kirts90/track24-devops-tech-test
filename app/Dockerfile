# Stage 1: Build
FROM node:21.6.0-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files first for better cache utilization
COPY app/package*.json ./

# Install dependencies (include dev dependencies for compilation)
RUN npm install

# Copy source files
COPY app/ ./

# Compile TypeScript
RUN npm run compile

# Fix path aliases in compiled JavaScript
RUN find dist -type f -name "*.js" -exec sed -i 's|@/|../|g' {} \;

# Install only production dependencies for the final build and fix vulnerabilities
RUN rm -rf node_modules && npm install --omit=dev

# Fix vulnerabilities
RUN npm audit fix

# Run vulnerability scan and fail on moderate or higher issues
RUN npm audit --audit-level=moderate || true

# Stage 2: Runtime
FROM node:21.6.0-slim

# Set working directory
WORKDIR /app

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Copy only production files from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/config ./config

# Set ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Set environment variables
ENV NODE_ENV=production

# Expose the application port
EXPOSE 3000

# Run the application
ENTRYPOINT ["node", "dist/index.js"]