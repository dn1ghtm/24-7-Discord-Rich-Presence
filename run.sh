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

# Check if polyfill script exists
if [ ! -f "/app/polyfill.js" ]; then
  bashio::log.info "Creating ReadableStream polyfill..."
  cat > /app/polyfill.js << EOL
// Polyfill for ReadableStream
if (typeof ReadableStream === 'undefined') {
  try {
    const { ReadableStream } = require('web-streams-polyfill/ponyfill');
    global.ReadableStream = ReadableStream;
    console.log('ReadableStream polyfill applied');
  } catch (error) {
    console.error('Failed to apply ReadableStream polyfill:', error.message);
    console.error('Attempting to install web-streams-polyfill...');
    require('child_process').execSync('npm install web-streams-polyfill@3.2.1');
    const { ReadableStream } = require('web-streams-polyfill/ponyfill');
    global.ReadableStream = ReadableStream;
    console.log('ReadableStream polyfill applied after installing package');
  }
} else {
  console.log('ReadableStream is already defined, no polyfill needed');
}
EOL
else
  bashio::log.info "ReadableStream polyfill already exists"
fi

# Install web-streams-polyfill if not already installed
if [ ! -d "/app/node_modules/web-streams-polyfill" ]; then
  bashio::log.warning "web-streams-polyfill not found, installing..."
  npm install web-streams-polyfill
fi

# Start the web server in the background with polyfill
bashio::log.info "Starting web interface on port 8099..."
node -r ./polyfill.js server.js > /tmp/server.log 2>&1 & 
WEB_SERVER_PID=$!
sleep 3 # Give the server a moment to start

# Check if the web server started successfully
if ! kill -0 $WEB_SERVER_PID 2>/dev/null; then
  bashio::log.error "Web server failed to start. Check /tmp/server.log for details."
  cat /tmp/server.log
  
  # Check for ReadableStream error
  if grep -q "ReadableStream is not defined" /tmp/server.log; then
    bashio::log.error "ReadableStream error detected. Attempting to fix..."
    
    # Install web-streams-polyfill if not already installed
    npm install web-streams-polyfill@3.2.1
    
    # Try starting the server again with explicit polyfill
    bashio::log.info "Retrying web server startup with explicit polyfill..."
    node -r ./polyfill.js server.js > /tmp/server_retry.log 2>&1 &
    WEB_SERVER_PID=$!
    sleep 3
    
    if ! kill -0 $WEB_SERVER_PID 2>/dev/null; then
      bashio::log.error "Web server still failed to start after polyfill attempt."
      cat /tmp/server_retry.log
    else
      bashio::log.info "Web server started successfully with polyfill. PID: $WEB_SERVER_PID"
    fi
  fi
else
  bashio::log.info "Web server started successfully with PID $WEB_SERVER_PID"
fi

# Start the Discord bot
bashio::log.info "Starting Discord bot..."
node index.js