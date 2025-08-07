#!/usr/bin/with-contenv bashio

# Get config values from Home Assistant
TOKEN=$(bashio::config 'discord_token')
APPLICATION_ID=$(bashio::config 'application_id')
TYPE=$(bashio::config 'type')
NAME=$(bashio::config 'name')
DETAILS=$(bashio::config 'details')
STATE=$(bashio::config 'state')
LARGE_IMAGE_KEY=$(bashio::config 'largeImageKey')
LARGE_IMAGE_TEXT=$(bashio::config 'largeImageText')
SMALL_IMAGE_KEY=$(bashio::config 'smallImageKey')
SMALL_IMAGE_TEXT=$(bashio::config 'smallImageText')
URL=$(bashio::config 'url')

# Get button information
BUTTON1_NAME=$(bashio::config 'buttons[0].name')
BUTTON1_URL=$(bashio::config 'buttons[0].url')
BUTTON2_NAME=$(bashio::config 'buttons[1].name')
BUTTON2_URL=$(bashio::config 'buttons[1].url')

# Create .env file with all configuration
cat > /app/.env << EOL
TOKEN=${TOKEN}
APPLICATION_ID=${APPLICATION_ID}
TYPE=${TYPE}
NAME=${NAME}
DETAILS=${DETAILS}
STATE=${STATE}
LARGE_IMAGE_KEY=${LARGE_IMAGE_KEY}
LARGE_IMAGE_TEXT=${LARGE_IMAGE_TEXT}
SMALL_IMAGE_KEY=${SMALL_IMAGE_KEY}
SMALL_IMAGE_TEXT=${SMALL_IMAGE_TEXT}
URL=${URL}
BUTTON1_NAME=${BUTTON1_NAME}
BUTTON1_URL=${BUTTON1_URL}
BUTTON2_NAME=${BUTTON2_NAME}
BUTTON2_URL=${BUTTON2_URL}
EOL

# Print startup message
bashio::log.info "Starting Discord 24/7 Rich Presence..."

# Start the app
cd /app
node index.js