const express = require('express');
const path = require('path');
const fs = require('fs');
const app = express();
const port = process.env.PORT || 8099;

// Log startup information
console.log('Starting Discord 24/7 Rich Presence web server...');
console.log(`Current directory: ${__dirname}`);
console.log(`Port: ${port}`);

// Check for required files
const indexHtmlPath = path.join(__dirname, 'index.html');
if (fs.existsSync(indexHtmlPath)) {
  console.log(`Found index.html at ${indexHtmlPath}`);
} else {
  console.error(`ERROR: index.html not found at ${indexHtmlPath}`);
}

// Store the start time when the server starts
const startTime = new Date();

// Serve static files
app.use(express.static(path.join(__dirname)));

// API endpoint to get current status
app.get('/api/status', (req, res) => {
  try {
    // Calculate uptime
    const now = new Date();
    const diff = now - startTime;
    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
    const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
    let uptimeText = '';
    if (days > 0) uptimeText += `${days}d `;
    uptimeText += `${hours}h ${minutes}m`;

    // Get current configuration
    const config = {
      type: process.env.TYPE || 'WATCHING',
      name: process.env.NAME || 'Youtube',
      details: process.env.DETAILS || 'Watching Nexos Creator',
      state: process.env.STATE || 'Subscribe',
      largeImageKey: process.env.LARGE_IMAGE_KEY || '1377844502521446490',
      largeImageText: process.env.LARGE_IMAGE_TEXT || 'Watching Nexos Creator',
      smallImageKey: process.env.SMALL_IMAGE_KEY || '1377845999464087653',
      smallImageText: process.env.SMALL_IMAGE_TEXT || 'Subscribe',
      url: process.env.URL || 'https://www.youtube.com/@nexoscreator',
      uptime: uptimeText,
      buttons: [],
      // Generate Discord CDN image URLs
      largeImageUrl: `https://cdn.discordapp.com/app-assets/${process.env.APPLICATION_ID || '1311204057490259979'}/${process.env.LARGE_IMAGE_KEY || '1377844502521446490'}.png`,
      smallImageUrl: `https://cdn.discordapp.com/app-assets/${process.env.APPLICATION_ID || '1311204057490259979'}/${process.env.SMALL_IMAGE_KEY || '1377845999464087653'}.png`
    };

    // Add buttons if they exist
    if (process.env.BUTTON1_NAME && process.env.BUTTON1_URL) {
      config.buttons.push({
        name: process.env.BUTTON1_NAME,
        url: process.env.BUTTON1_URL
      });
    }

    if (process.env.BUTTON2_NAME && process.env.BUTTON2_URL) {
      config.buttons.push({
        name: process.env.BUTTON2_NAME,
        url: process.env.BUTTON2_URL
      });
    }

    res.json(config);
  } catch (error) {
    console.error('Error generating status:', error);
    res.status(500).json({ error: 'Failed to get status' });
  }
});

// Default route serves the index.html
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

// Start the server
app.listen(port, () => {
  console.log(`Web interface running on port ${port}`);
}).on('error', (error) => {
  console.error('Error starting web server:', error.message);
  // If the port is already in use, try another port
  if (error.code === 'EADDRINUSE') {
    console.log('Port already in use, trying another port...');
    const newPort = parseInt(port) + 1;
    app.listen(newPort, () => {
      console.log(`Web interface running on alternative port ${newPort}`);
    });
  }
});