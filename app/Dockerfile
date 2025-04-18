# Build Stage
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies for prod
COPY package*.json ./
RUN npm ci --omit=dev

# Copy source code
COPY . .
RUN npm run compile

# Production Stage
FROM node:20-alpine AS runner

WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY package*.json ./

# Create a non-root user and switch to it for secruity purposes
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 3000
CMD ["node", "dist/index.js"]