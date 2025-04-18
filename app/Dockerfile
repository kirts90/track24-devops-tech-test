# Build Stage
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies for prod
COPY package*.json ./
RUN npm ci 

# Copy source code
COPY . .
RUN npm run compile

# Remove dev dependencies
RUN npm prune --production

# Remove unnecessary files to reduce image size
RUN rm -rf src tests .git .github .vscode .eslintignore .eslintrc.js .prettierrc.json .npmrc README.md

# Production Stage
FROM node:20-alpine AS runner

WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY package*.json ./
COPY config ./config

# Create a non-root user and switch to it for secruity purposes
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 9002
CMD ["node", "dist/index.js"]