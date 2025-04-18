# 2: Build Stage
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