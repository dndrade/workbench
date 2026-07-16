# syntax=docker/dockerfile:1.7

FROM oven/bun:1.3.14 AS dependencies
WORKDIR /app

COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

FROM dependencies AS builder
COPY . .
RUN bun run build

# adapter-node produces a Node server. Use an LTS runtime, not the dev image.
FROM node:24-bookworm-slim AS runtime
WORKDIR /app

ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3000

RUN groupadd --system --gid 10001 app \
	&& useradd --system --uid 10001 --gid app --home-dir /app app

COPY --from=builder --chown=app:app /app/build ./build
COPY --from=builder --chown=app:app /app/package.json ./package.json
COPY --from=builder --chown=app:app /app/node_modules ./node_modules

USER app

EXPOSE 3000

CMD ["node", "build"]
