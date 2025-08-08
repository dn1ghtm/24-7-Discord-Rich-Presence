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

# Ensure web-streams-polyfill is installed
bashio::log.info "Ensuring web-streams-polyfill is installed..."
cd /app && npm install web-streams-polyfill@3.2.1

# Check if polyfill script exists or create it
if [ ! -f "/app/polyfill.js" ]; then
  bashio::log.info "Creating enhanced Web Streams API polyfill..."
  cat > /app/polyfill.js << EOL
// Enhanced polyfill for ReadableStream and related web streams APIs
try {
  // Load the full polyfill package
  const webStreams = require('web-streams-polyfill');
  
  // Apply all web streams polyfills to global scope
  if (typeof ReadableStream === 'undefined') {
    global.ReadableStream = webStreams.ReadableStream;
    console.log('ReadableStream polyfill applied');
  }
  
  if (typeof WritableStream === 'undefined') {
    global.WritableStream = webStreams.WritableStream;
    console.log('WritableStream polyfill applied');
  }
  
  if (typeof TransformStream === 'undefined') {
    global.TransformStream = webStreams.TransformStream;
    console.log('TransformStream polyfill applied');
  }
  
  if (typeof ByteLengthQueuingStrategy === 'undefined') {
    global.ByteLengthQueuingStrategy = webStreams.ByteLengthQueuingStrategy;
    console.log('ByteLengthQueuingStrategy polyfill applied');
  }
  
  if (typeof CountQueuingStrategy === 'undefined') {
    global.CountQueuingStrategy = webStreams.CountQueuingStrategy;
    console.log('CountQueuingStrategy polyfill applied');
  }
  
  console.log('Web Streams API polyfills successfully applied');
} catch (error) {
  console.error('Failed to apply Web Streams polyfills:', error.message);
  console.error('Attempting to install web-streams-polyfill...');
  try {
    require('child_process').execSync('npm install web-streams-polyfill@3.2.1');
    const webStreams = require('web-streams-polyfill');
    
    // Apply all web streams polyfills to global scope
    global.ReadableStream = webStreams.ReadableStream;
    global.WritableStream = webStreams.WritableStream;
    global.TransformStream = webStreams.TransformStream;
    global.ByteLengthQueuingStrategy = webStreams.ByteLengthQueuingStrategy;
    global.CountQueuingStrategy = webStreams.CountQueuingStrategy;
    
    console.log('Web Streams API polyfills successfully applied after installing package');
  } catch (installError) {
    console.error('Critical error: Failed to install and apply Web Streams polyfills:', installError.message);
    process.exit(1); // Exit with error code to prevent further issues
  }
}
EOL
else
  bashio::log.info "Web Streams API polyfill already exists"
fi

# Start the web server in the background with polyfill
bashio::log.info "Starting web interface on port 8099..."

# Use NODE_OPTIONS to ensure polyfill is loaded before any modules
export NODE_OPTIONS="--require ./polyfill.js"
node server.js > /tmp/server.log 2>&1 & 
WEB_SERVER_PID=$!
sleep 5 # Give the server more time to start and apply polyfills

# Check if the web server started successfully
if ! kill -0 $WEB_SERVER_PID 2>/dev/null; then
  bashio::log.error "Web server failed to start. Check /tmp/server.log for details."
  cat /tmp/server.log
  
  # Check for ReadableStream or undici errors
  if grep -q "ReadableStream is not defined\|undici\|web-streams" /tmp/server.log; then
    bashio::log.error "Web Streams API error detected. Attempting comprehensive fix..."
    
    # Force reinstall web-streams-polyfill and undici
    bashio::log.info "Reinstalling web-streams-polyfill and fixing undici..."
    cd /app
    npm uninstall web-streams-polyfill
    npm install web-streams-polyfill@3.2.1
    
    # Create a patch for undici if needed
    if grep -q "undici" /tmp/server.log; then
      bashio::log.info "Creating patch for undici..."
      mkdir -p /app/patches
      cat > /app/patches/undici-fix.js << EOL
// Patch for undici to ensure ReadableStream is available
if (typeof ReadableStream === 'undefined') {
  const webStreams = require('web-streams-polyfill');
  global.ReadableStream = webStreams.ReadableStream;
  global.WritableStream = webStreams.WritableStream;
  global.TransformStream = webStreams.TransformStream;
  global.ByteLengthQueuingStrategy = webStreams.ByteLengthQueuingStrategy;
  global.CountQueuingStrategy = webStreams.CountQueuingStrategy;
  console.log('Applied undici-specific Web Streams API patch');
}
EOL
    fi
    
    # Try starting the server again with enhanced polyfill approach
    bashio::log.info "Retrying web server startup with enhanced polyfill approach..."
    export NODE_OPTIONS="--require ./polyfill.js"
    if [ -f "/app/patches/undici-fix.js" ]; then
      export NODE_OPTIONS="$NODE_OPTIONS --require ./patches/undici-fix.js"
    fi
    
    node server.js > /tmp/server_retry.log 2>&1 &
    WEB_SERVER_PID=$!
    sleep 5
    
    if ! kill -0 $WEB_SERVER_PID 2>/dev/null; then
      bashio::log.error "Web server still failed to start after enhanced polyfill attempt."
      cat /tmp/server_retry.log
      
      # Last resort: try with a direct patch to node_modules
      bashio::log.warning "Attempting direct patch to undici module..."
      UNDICI_PATH=$(find /app/node_modules -path "*/undici/lib/web/fetch/response.js" | head -n 1)
      
      if [ ! -z "$UNDICI_PATH" ]; then
        bashio::log.info "Found undici at $UNDICI_PATH, applying direct patch..."
        sed -i 's/ReadableStream/global.ReadableStream/g' "$UNDICI_PATH"
        
        # Try one more time
        node server.js > /tmp/server_final.log 2>&1 &
        WEB_SERVER_PID=$!
        sleep 5
        
        if ! kill -0 $WEB_SERVER_PID 2>/dev/null; then
          bashio::log.error "All recovery attempts failed. Please check logs."
          cat /tmp/server_final.log
        else
          bashio::log.info "Web server started successfully after direct patch. PID: $WEB_SERVER_PID"
        fi
      else
        bashio::log.error "Could not locate undici module for direct patching."
      fi
    else
      bashio::log.info "Web server started successfully with enhanced polyfill. PID: $WEB_SERVER_PID"
    fi
  else
    # Handle other types of errors
    bashio::log.error "Unknown error prevented web server startup."
  fi
else
  bashio::log.info "Web server started successfully with PID $WEB_SERVER_PID"
fi

# Start the Discord bot
bashio::log.info "Starting Discord bot..."
node index.js