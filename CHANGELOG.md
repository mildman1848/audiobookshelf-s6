# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Support for future features like additional mods or enhanced testing.
- Integrated Release Drafter for automated drafting of release notes based on PR labels and commits.

### Changed
- Updated release-drafter configuration to include custom categories (Features, Bug Fixes, Maintenance), version resolver, and autolabeler for better automation.

## [1.0.0] - 2025-07-18

### Added
- Initial release of the audiobookshelf-s6 Docker image.
- Integration of s6-overlay for process supervision.
- Support for Docker mods via `DOCKER_MODS` environment variable.
- Docker secrets handling with `FILE__` prefix.
- User/group mapping via `PUID` and `PGID`.
- Multi-architecture support (amd64, arm64, arm/v7).
- GitHub Actions for automated builds, pushes to GHCR and Docker Hub.
- Dependabot configuration for updates.
- Services and scripts copied from repo root for maintainability.
- README.md with usage examples and documentation.

### Fixed
- N/A (initial release).

### Changed
- Base image set to `ghcr.io/advplyr/audiobookshelf:latest` with configurable tag.

### Deprecated
- N/A.

### Removed
- N/A.

### Security
- Added vulnerability scanning suggestions in workflows.