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

ARG APP_PORT

WORKDIR /app

COPY --from=builder /app/dist/frontodonto/browser ./dist

RUN npm install -g serve

EXPOSE $APP_PORT

CMD ["serve", "-s", "dist", "-l", $APP_PORT]