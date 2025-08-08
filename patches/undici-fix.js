// Patch for undici to ensure ReadableStream is available
if (typeof ReadableStream === "undefined") {
  try {
    const webStreams = require("web-streams-polyfill");
    global.ReadableStream = webStreams.ReadableStream;
    global.WritableStream = webStreams.WritableStream;
    global.TransformStream = webStreams.TransformStream;
    global.ByteLengthQueuingStrategy = webStreams.ByteLengthQueuingStrategy;
    global.CountQueuingStrategy = webStreams.CountQueuingStrategy;
    console.log("Applied undici-specific Web Streams API patch");
  } catch (error) {
    console.error("Failed to load web-streams-polyfill, attempting to install it:", error);
    try {
      require('child_process').execSync('npm install web-streams-polyfill@3.2.1', { stdio: 'inherit' });
      const webStreams = require("web-streams-polyfill");
      global.ReadableStream = webStreams.ReadableStream;
      global.WritableStream = webStreams.WritableStream;
      global.TransformStream = webStreams.TransformStream;
      global.ByteLengthQueuingStrategy = webStreams.ByteLengthQueuingStrategy;
      global.CountQueuingStrategy = webStreams.CountQueuingStrategy;
      console.log("Successfully installed and applied web-streams-polyfill");
    } catch (installError) {
      console.error("Critical error: Failed to install web-streams-polyfill:", installError);
      process.exit(1);
    }
  }
}