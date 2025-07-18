# Dockerfile

# Build arguments for versions (allows updates without changing Dockerfile)
ARG BASE_IMAGE_TAG=latest
ARG S6_OVERLAY_VERSION=3.2.0.0

# Use multi-stage or dynamic arch via $TARGETARCH (provided by buildx)
FROM ghcr.io/advplyr/audiobookshelf:${BASE_IMAGE_TAG}

# Install required tools and s6-overlay (multi-arch compatible)
RUN apk add --no-cache curl xz && \
    # Download noarch tarball
    curl -L "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" -o /tmp/noarch.tar.xz && \
    tar -C / -Jxpf /tmp/noarch.tar.xz && \
    # Download arch-specific tarball (uses $TARGETARCH: amd64 -> x86_64, arm64 -> aarch64, etc.)
    ARCH=$(case ${TARGETARCH} in \
      "amd64") echo "x86_64" ;; \
      "arm64") echo "aarch64" ;; \
      "arm/v7") echo "armhf" ;; \
      *) echo "${TARGETARCH}" ;; \
    esac) && \
    curl -L "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${ARCH}.tar.xz" -o /tmp/arch.tar.xz && \
    tar -C / -Jxpf /tmp/arch.tar.xz && \
    # Optional symlinks
    curl -L "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz" -o /tmp/symlinks-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/symlinks-noarch.tar.xz && \
    curl -L "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-${ARCH}.tar.xz" -o /tmp/symlinks-arch.tar.xz && \
    tar -C / -Jxpf /tmp/symlinks-arch.tar.xz && \
    # Cleanup
    rm /tmp/*.tar.xz && \
    rm -rf /var/cache/apk/*

# Copy s6 services, scripts, etc. from repo (multi-arch agnostic)
COPY root/ /

# Environment variables for linuxserver.io-like features
ENV PUID=1000 PGID=1000

# Set s6 as entrypoint
ENTRYPOINT ["/init"]