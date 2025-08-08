ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.15
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install Node.js and npm (using a newer version that supports ReadableStream)
RUN apk add --no-cache nodejs>=16.0.0 npm curl bash

# Install web-streams-polyfill as fallback for ReadableStream
RUN npm install -g web-streams-polyfill

# Copy data for add-on
COPY . /app
WORKDIR /app

# Install dependencies
RUN npm install && npm install express@4.21.2

# Copy run script and ensure proper permissions
COPY run.sh /
RUN chmod a+x /run.sh
RUN chmod -R 755 /app
RUN chmod 644 /app/server.js /app/index.html /app/index.js
RUN touch /app/polyfill.js && chmod 644 /app/polyfill.js

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Adapted from nexoscreator" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.authors="Adapted from nexoscreator" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/nexoscreation/discord-24-7-rich-presence" \
    org.opencontainers.image.source="${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/nexoscreation/discord-24-7-rich-presence/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:8099/ || exit 1

CMD [ "/run.sh" ]