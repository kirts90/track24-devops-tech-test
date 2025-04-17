# Build Stage
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies for prod
COPY package*.json ./
RUN npm ci --omit=dev

# Copy source code
COPY . .
RUN npm run compile
