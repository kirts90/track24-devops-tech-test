# 1: Build Stage
FROM node:20-alpine AS builder

WORKDIR /app

# Use cache by copying package files only first
COPY app/package*.json ./

# Install dependencies
COPY package*.json ./
RUN npm ci --omit=dev

# Copy app source
COPY app/. .

# Run the app
RUN npm run compile

# Remove unwanted dependencies to reduce image size
RUN npm prune --production

# 2: Runtime Stage
FROM node:20-alpine AS runner

# Create a non-root user
RUN addgroup -S inquiron && adduser -S inquiron -G inquiron

WORKDIR /app

# Copy files from the builder
COPY --from=builder /app /app

# Set ownership and permissions - owner read perms, others read only
RUN chown -R inquiron:inquiron /app && \
    chmod -R 644 /app

USER inquiron

# Expose port 9002 (as seen in app/config/default.yaml)
EXPOSE 9002

# Startup command
CMD ["node", "dist/index.js"]