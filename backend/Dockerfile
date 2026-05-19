FROM node:22-bookworm-slim AS workspace-base

WORKDIR /app

COPY package.json package-lock.json ./
COPY backend/package.json backend/package.json
COPY frontend/package.json frontend/package.json
COPY lib/package.json lib/package.json

FROM workspace-base AS production-deps

RUN npm ci --omit=dev

FROM workspace-base AS development-deps

RUN npm ci

FROM node:22-bookworm-slim AS runtime

WORKDIR /app
ENV NODE_ENV=production

COPY --from=production-deps /app/node_modules ./node_modules
COPY package.json package-lock.json ./
COPY backend ./backend
COPY lib ./lib
COPY openapi.yaml ./openapi.yaml

EXPOSE 3001

CMD ["npm", "run", "start", "--workspace", "backend"]

FROM node:22-bookworm-slim AS development

WORKDIR /app
ENV NODE_ENV=development

COPY --from=development-deps /app/node_modules ./node_modules
COPY package.json package-lock.json ./
COPY backend ./backend
COPY lib ./lib
COPY openapi.yaml ./openapi.yaml

EXPOSE 3001

CMD ["npm", "run", "dev", "--workspace", "backend"]
