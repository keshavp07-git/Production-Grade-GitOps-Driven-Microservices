
# Build stage
FROM node:20-bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --omit=dev

# Runtime stage
FROM node:20-bookworm-slim

WORKDIR /usr/src/app

ENV NODE_ENV=production

COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY . .

EXPOSE 50051

ENTRYPOINT ["node", "index.js"]
