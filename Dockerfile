# Use official Bun image for building
FROM oven/bun:latest AS builder

# Set working directory
WORKDIR /app

# Copy the rest of the application
COPY . .

# Copy .env file so Prisma can access the database URL
COPY .env .env

RUN apt-get update -y && apt-get install -y openssl libssl-dev wget curl

# Install dependencies
RUN bun install

# Build the app
RUN bun run build:default

# Generate Prisma client
RUN bun run prisma generate

# Use a lighter runtime image
FROM oven/bun:latest AS runner

# Set working directory
WORKDIR /app

RUN apt-get update -y && apt-get install -y openssl libssl-dev wget curl

# Copy only the built files and node_modules from the builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/firebase-service-account-key.json ./firebase-service-account-key.json
# Copy the service account file to the utils directory
COPY firebase-service-account-key.json /app/utils/firebase-service-account-key.json

# Or if your build output is in dist/
COPY firebase-service-account-key.json /app/src/utils/firebase-service-account-key.json

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/.env .env 

# Expose application port
EXPOSE 4000

# Add healthcheck command
HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:4000/health || exit 1

# Run the application
CMD ["bun", "run", "start"]
