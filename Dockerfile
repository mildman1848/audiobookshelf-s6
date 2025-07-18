# Dockerfile

# Build arguments for versions (allows updates without changing Dockerfile)
ARG BASE_IMAGE_TAG=3.20  # linuxserver/baseimage-alpine version
ARG NODE_VERSION=20
ARG APP_VERSION=v2.26.1  # Audiobookshelf version/tag

# Stage 1: Builder - Build the Audiobookshelf app (based on original logic)
FROM node:${NODE_VERSION}-alpine AS builder

# Install runtime dependencies (from original Audiobookshelf Dockerfile)
RUN apk add --no-cache \
    ffmpeg \
    python3 \
    tini \
    tzdata \
    git

# Set workdir and clone repo
WORKDIR /app
RUN git clone https://github.com/advplyr/audiobookshelf.git . && \
    git checkout ${APP_VERSION}

# Install in server directory
WORKDIR /app/server
RUN npm install

# Install and build in client directory
WORKDIR /app/client
RUN npm install && \
    npm run prod

# Install in root
WORKDIR /app
RUN npm install

# Cleanup
RUN rm -rf /tmp/* /var/cache/apk/*

# Stage 2: Final - Use linuxserver baseimage (includes s6, mods, secrets)
FROM ghcr.io/linuxserver/baseimage-alpine:${BASE_IMAGE_TAG}

# Install Node and runtime dependencies (since base is Alpine)
RUN apk add --no-cache \
    nodejs \
    npm \
    ffmpeg \
    python3 \
    tini \
    tzdata

# Copy built app from builder stage to root
COPY --from=builder /app /

# Set workdir to root
WORKDIR /

# Copy s6 services and scripts from repo (for app start)
COPY root/ /

# Environment variables for linuxserver.io features (integrated in base)
ENV PUID=1000 PGID=1000 \
    HOME=/app

# Volumes (as in original)
VOLUME /config /audiobooks /podcasts /metadata

# Expose port
EXPOSE 80

# Set s6 entrypoint (already in linuxserver base: /init)
ENTRYPOINT ["/init"]