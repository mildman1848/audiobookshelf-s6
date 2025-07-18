# audiobookshelf-s6

This repository provides a Docker image for [Audiobookshelf](https://github.com/advplyr/audiobookshelf), adapted to follow the best practices of [linuxserver.io](https://www.linuxserver.io/). It uses s6-overlay for process supervision, supports Docker mods, Docker secrets, and is multi-architecture compatible (amd64, arm64, arm/v7, etc.). The original Audiobookshelf Dockerfile is not modified; this is a wrapper image built on top of `ghcr.io/advplyr/audiobookshelf:latest`.

## Features
- **Base Image**: Built on the official multi-arch Audiobookshelf image.
- **s6-overlay**: For reliable process management and supervision.
- **Docker Mods**: Support for the `DOCKER_MODS` environment variable to install custom mods (tarballs) at runtime, similar to linuxserver.io.
- **Docker Secrets**: Load environment variables from secrets/files using the `FILE__` prefix (e.g., `FILE__PASSWORD=/run/secrets/my_password`).
- **User/Group Mapping**: Via `PUID` and `PGID` environment variables for better volume permission handling.
- **Versions Configurable**: All versions (e.g., s6-overlay, base image tag) are set via build arguments, allowing updates without changing the Dockerfile.
- **Services and Scripts**: Stored in the repo under `/root` and copied into the image for easy maintenance.
- **CI/CD**: Automated builds and pushes to GHCR and Docker Hub via GitHub Actions, with Dependabot for updates.
- **Multi-Arch Support**: Builds for linux/amd64, linux/arm64, linux/arm/v7 using Docker Buildx.

## Usage

### Docker Run Example
```bash
docker run -d \
  --name audiobookshelf \
  -e PUID=1000 \
  -e PGID=1000 \
  -p 13378:80 \
  -v /path/to/config:/config \
  -v /path/to/audiobooks:/audiobooks \
  -v /path/to/podcasts:/podcasts \
  -v /path/to/metadata:/metadata \
  ghcr.io/mildman1848/audiobookshelf-s6:latest
```

### Docker Compose Example
```yaml
services:
  audiobookshelf:
    image: ghcr.io/mildman1848/audiobookshelf-s6:latest
    container_name: audiobookshelf
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - /path/to/config:/config
      - /path/to/audiobooks:/audiobooks
      - /path/to/podcasts:/podcasts
      - /path/to/metadata:/metadata
    ports:
      - 13378:80
    restart: unless-stopped
```

## Environment Variables
| Variable       | Description                                                                 | Default |
|----------------|-----------------------------------------------------------------------------|---------|
| `PUID`         | User ID for volume permissions (maps to the `abc` user inside the container). | 1000   |
| `PGID`         | Group ID for volume permissions.                                            | 1000   |
| `DOCKER_MODS`  | Colon-separated list of URLs to mod tarballs (e.g., `https://example.com/mod.tar.gz:https://another.com/mod2.tar.gz`). Mods are installed during container startup. | (none) |
| `FILE__<VAR>`  | Prefix for loading env vars from Docker secrets/files (e.g., `FILE__TZ=/run/secrets/timezone` sets `TZ`). | (none) |

## Volumes
- `/config`: Configuration files and database.
- `/audiobooks`: Directory for audiobook files.
- `/podcasts`: Directory for podcast files.
- `/metadata`: Metadata storage.

## Building Locally
To build the image locally with custom versions:
```bash
docker buildx build \
  --build-arg S6_OVERLAY_VERSION=3.2.0.0 \
  --build-arg BASE_IMAGE_TAG=latest \
  -t mildman1848/audiobookshelf-s6:latest .
```

For multi-arch builds, ensure Docker Buildx is enabled.

## Updates and Maintenance
- **Dependabot**: Configured to check weekly for Docker base image updates and GitHub Actions versions. Pull requests are automatically opened.
- **GitHub Actions**: 
  - Builds and pushes images to GHCR and Docker Hub on pushes to `main`, tags, PRs, and weekly schedules.
  - Additional workflows for linting (Dockerfile), vulnerability scanning (Trivy), and testing can be added (see suggestions in the conversation history).
- To update versions like s6-overlay, pass new build args during builds—no Dockerfile changes needed.

## Contributing
- Fork the repository and submit pull requests.
- Report issues via GitHub Issues.
- For custom mods, create tarballs with s6-compatible scripts/services and reference them via `DOCKER_MODS`.

## License
This project is licensed under the MIT License. It builds upon the original [Audiobookshelf](https://github.com/advplyr/audiobookshelf) (licensed under GPL-3.0) and [s6-overlay](https://github.com/just-containers/s6-overlay) (licensed under MIT). Please respect the licenses of upstream projects.

## Credits
- Inspired by [linuxserver.io](https://www.linuxserver.io/) Docker images.
- Original app: [advplyr/audiobookshelf](https://github.com/advplyr/audiobookshelf).
- Process supervision: [just-containers/s6-overlay](https://github.com/just-containers/s6-overlay).