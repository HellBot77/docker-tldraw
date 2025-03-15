FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/tldraw/tldraw.git && \
    cd tldraw && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:20-alpine AS build

WORKDIR /tldraw
COPY --from=base /git/tldraw .
RUN corepack enable && \
    corepack install && \
    yarn && \
    export NODE_ENV=production && \
    yarn build-app

FROM lipanski/docker-static-website

COPY --from=build /tldraw/apps/dotcom/client/dist .
