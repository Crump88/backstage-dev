# syntax=docker/dockerfile:1.7

FROM node:24-trixie-slim AS builder

ENV PYTHON=/usr/bin/python3

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends python3 g++ build-essential libsqlite3-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY .yarn ./.yarn
COPY .yarnrc.yml ./
COPY package.json yarn.lock backstage.json ./
COPY app-config*.yaml ./
COPY packages ./packages
COPY plugins ./plugins
COPY examples ./examples

RUN --mount=type=cache,target=/root/.cache/yarn,sharing=locked yarn install --immutable
RUN yarn tsc
RUN yarn build:backend

FROM node:24-trixie-slim

ENV PYTHON=/usr/bin/python3
ENV NODE_ENV=production
ENV NODE_OPTIONS=--no-node-snapshot

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends python3 g++ build-essential libsqlite3-dev ca-certificates && \
    rm -rf /var/lib/apt/lists/*

USER node
WORKDIR /app

COPY --from=builder --chown=node:node /app .

RUN --mount=type=cache,target=/home/node/.cache/yarn,sharing=locked,uid=1000,gid=1000 \
    yarn workspaces focus --all --production && rm -rf "$(yarn cache clean)"

EXPOSE 7007

CMD ["node", "packages/backend", "--config", "app-config.yaml", "--config", "app-config.production.yaml"]
