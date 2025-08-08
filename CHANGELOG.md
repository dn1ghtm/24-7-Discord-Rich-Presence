# Changelog

## 1.0.6

- Fixed specific undici module error: "Cannot set properties of undefined (setting 'ReadableStream')" by creating a dedicated patch file
- Added global scope polyfill for all Web Streams API components to ensure compatibility with undici
- Upgraded Node.js version requirement from 18.17.0+ to 20.18.0+ to support discord.js-selfbot-v13 and undici dependencies
- Updated Alpine Linux base image from 3.15 to 3.22 to better support Node.js 20.18.0+
- Fixed npm engine warnings by ensuring compatibility with all required dependencies
- Updated version to 1.0.6 to reflect stable release with all critical fixes

## 0.1.5

- Changed base image source from GitHub Container Registry (ghcr.io) to Docker Hub (homeassistant) to resolve TLS handshake timeout issues
- Improved build reliability for all supported architectures
- Fixed persistent ReadableStream not defined error by upgrading Node.js to version 20.18.0+
- Enhanced Web Streams API polyfill to include all required stream types (ReadableStream, WritableStream, TransformStream)
- Added direct patching of undici module to fix ReadableStream references
- Implemented multi-layer recovery approach for ReadableStream errors
- Added comprehensive error detection and automatic recovery for web server startup
- Created specialized patches for undici compatibility
- Ensured web-streams-polyfill is always installed before server startup

## 0.1.4

- Changed base image source from GitHub Container Registry (ghcr.io) to Docker Hub (homeassistant) to resolve TLS handshake timeout issues
- Improved build reliability for all supported architectures
- Fixed persistent ReadableStream not defined error by upgrading Node.js version
- Enhanced Web Streams API polyfill to include all required stream types (ReadableStream, WritableStream, TransformStream)
- Added direct patching of undici module to fix ReadableStream references
- Implemented multi-layer recovery approach for ReadableStream errors
- Added comprehensive error detection and automatic recovery for web server startup
- Created specialized patches for undici compatibility
- Ensured web-streams-polyfill is always installed before server startup

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