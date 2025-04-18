# 1: Build Stage
FROM node:20-alpine AS builder

WORKDIR /app

# Use cache by copying package files only first
COPY app/package*.json ./

# Install dependencies
COPY package*.json ./
RUN npm ci --omit=dev

# Copy app
COPY . .

# Run the app
RUN npm run compile

# 2: Runtime Stage
FROM node:20-alpine

# Create a non-root user
RUN addgroup -S inquiron && adduser -S inquiron -G inquiron

WORKDIR /app

# Copy only necessary files from the builder
COPY --from=builder /app /app

# Set ownership and permissions
RUN chown -R inquiron:inquiron /app && \
    chmod -R 755 /app

USER inquiron

# Expose port 9002 (as seen in app/config/default.yaml)
EXPOSE 9002

# Startup command
CMD ["node", "dist/index.js"]