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