# Use an official Node.js runtime as the base image
FROM node:20-alpine AS builder

WORKDIR /app
COPY app/package*.json ./

# Install dependencies, omitting development dependencies
RUN npm i --omit dev
# Copy the rest of the application files and install
COPY app ./
RUN npm install --save-dev @types/koa-pino-logger @types/config @types/koa__router 
RUN npm run compile 

# Use a minimal runtime image
FROM node:20-alpine AS runtime

RUN npm install -g npm@10.9.2  && npm cache clean --force
ENV NODE_ENV=production
WORKDIR /app
# Set appropriate permissions
RUN chown -R node:node /app
USER node
# Copy only the necessary files from the builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/config ./config
EXPOSE 9002
# Define the entrypoint
CMD ["node", "dist/index.js"]