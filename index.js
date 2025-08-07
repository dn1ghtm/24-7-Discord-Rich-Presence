const { Client } = require("discord.js-selfbot-v13");
const { CustomStatus, RichPresence } = require("discord.js-selfbot-v13");
const client = new Client();
require("dotenv").config();

// Use environment variables from .env file (created by run.sh from Home Assistant config)

const customStatus = new CustomStatus(client, {
  state: "Watching tutorials",
  emoji: { name: "🔥" },
});

// Parse buttons from environment variables
const buttons = [];
if (process.env.BUTTON1_NAME && process.env.BUTTON1_URL) {
  buttons.push({
    name: process.env.BUTTON1_NAME,
    url: process.env.BUTTON1_URL
  });
}
if (process.env.BUTTON2_NAME && process.env.BUTTON2_URL) {
  buttons.push({
    name: process.env.BUTTON2_NAME,
    url: process.env.BUTTON2_URL
  });
}

const rich = new RichPresence(client)
  .setApplicationId(process.env.APPLICATION_ID)
  .setType(process.env.TYPE)
  .setName(process.env.NAME)
  .setDetails(process.env.DETAILS)
  .setState(process.env.STATE)
  .setAssetsLargeImage(process.env.LARGE_IMAGE_KEY)
  .setAssetsLargeText(process.env.LARGE_IMAGE_TEXT)
  .setAssetsSmallImage(process.env.SMALL_IMAGE_KEY)
  .setAssetsSmallText(process.env.SMALL_IMAGE_TEXT)
  .setURL(process.env.URL)
  .setStartTimestamp(new Date())
  .setButtons(buttons);

/**
 * When the selfbot is ready and connected to Discord,
 * this function is executed.
 */
client.on("ready", async () => {
  console.log(`✅ ${client.user.username} is ready!`);
  client.user.setPresence({
    activities: [customStatus.toJSON(), rich.toJSON()],
    status: "online",
  });
  console.log("✅ Rich Presence is now active!");
});

// Log in using your user token
client.login(process.env.TOKEN);
