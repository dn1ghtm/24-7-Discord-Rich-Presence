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