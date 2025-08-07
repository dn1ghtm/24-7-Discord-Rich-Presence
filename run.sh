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

# Log image keys for debugging
bashio::log.info "Large Image Key: ${LARGE_IMAGE_KEY}"
bashio::log.info "Small Image Key: ${SMALL_IMAGE_KEY}"

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

# Verify environment variables are set correctly
bashio::log.info "Environment variables set in .env file"
bashio::log.info "APPLICATION_ID: ${APPLICATION_ID}"
bashio::log.info "LARGE_IMAGE_KEY: ${LARGE_IMAGE_KEY}"
bashio::log.info "SMALL_IMAGE_KEY: ${SMALL_IMAGE_KEY}"

# Set port for web interface
echo "PORT=8099" >> /app/.env

# Print startup message
bashio::log.info "Starting Discord 24/7 Rich Presence..."

# Check if express module is installed
if [ ! -d "/app/node_modules/express" ]; then
  bashio::log.warning "Express module not found, installing..."
  cd /app && npm install express@4.21.2
fi

# Start the app and web server
cd /app

# Start the web server in the background
bashio::log.info "Starting web interface on port 8099..."
node server.js > /tmp/server.log 2>&1 & 
WEB_SERVER_PID=$!
sleep 3 # Give the server a moment to start

# Check if the web server started successfully
if ! kill -0 $WEB_SERVER_PID 2>/dev/null; then
  bashio::log.error "Web server failed to start. Check /tmp/server.log for details."
  cat /tmp/server.log
else
  bashio::log.info "Web server started successfully with PID $WEB_SERVER_PID"
fi

# Start the Discord bot
bashio::log.info "Starting Discord bot..."
node index.js