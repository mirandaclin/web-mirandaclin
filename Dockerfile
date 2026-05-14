# ── Build stage ──────────────────────────────────────────────────────────────
FROM node:22-alpine AS builder

ARG SERVER_DNS

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npx ng build --configuration=production

RUN apk add --no-cache gettext && \
    envsubst '${SERVER_DNS}' \
      < /app/dist/frontodonto/browser/assets/env.js.template \
      > /app/dist/frontodonto/browser/assets/env.js

# ── Runtime stage ─────────────────────────────────────────────────────────────
FROM node:22-alpine

WORKDIR /app

COPY --from=builder /app/dist/frontodonto/browser ./dist

RUN npm install -g serve

EXPOSE 4200

CMD ["serve", "-s", "dist", "-l", "4200"]