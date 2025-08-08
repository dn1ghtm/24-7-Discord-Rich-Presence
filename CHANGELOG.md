# Changelog

## 0.1.4

- Changed base image source from GitHub Container Registry (ghcr.io) to Docker Hub (homeassistant) to resolve TLS handshake timeout issues
- Improved build reliability for all supported architectures

## 0.1.3

- Fixed ReadableStream not defined error in Node.js environment
- Added web-streams-polyfill for compatibility with older Node.js versions
- Updated Node.js version requirements

## 0.1.2

- Fixed installation issues with Docker container
- Improved error handling in web server
- Added healthcheck for better container stability
- Enhanced AppArmor profile for proper file permissions
- Added automatic recovery for web server startup issues
- Improved logging for easier troubleshooting

## 0.1.1

- Added web interface accessible from Home Assistant dashboard
- Added display of Discord Rich Presence images in web interface
- Added real-time status monitoring with automatic updates
- Improved documentation with web interface details

## 0.1.0

- Initial release as a Home Assistant add-on
- Added configuration through Home Assistant UI
- Added documentation for add-on usage
- Converted project structure to Home Assistant add-on format

## 0.0.1

- Initial release as a standalone Node.js application
- Basic Discord Rich Presence functionality
- Configuration through config.json and .env files