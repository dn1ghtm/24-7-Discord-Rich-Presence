# Discord 24/7 Rich Presence Add-on for Home Assistant

## Overview

This add-on allows you to keep your Discord account online 24/7 with a custom Rich Presence status. It shows games, music, or any activity—even when you're AFK. The add-on is lightweight and simple to use.

The add-on includes a web interface accessible from your Home Assistant dashboard, allowing you to monitor your Discord Rich Presence status and view the images being displayed.

## Installation

1. Add this repository to your Home Assistant instance.
2. Install the "Discord 24/7 Rich Presence" add-on.
3. Configure the add-on (see configuration section below).
4. Start the add-on.

## Configuration

### Required Configuration

```yaml
discord_token: "YOUR_DISCORD_TOKEN"
```

You need to provide your Discord user token. Please note that using user tokens with selfbots is against Discord's Terms of Service. This add-on is provided for educational purposes only.

### Optional Configuration

All other configuration options have default values but can be customized:

```yaml
application_id: "1311204057490259979"
type: "WATCHING"
name: "Youtube"
details: "Watching Nexos Creator"
state: "Subscribe"
largeImageKey: "1377844502521446490"
largeImageText: "Watching Nexos Creator"
smallImageKey: "1377845999464087653"
smallImageText: "Subscribe"
url: "https://www.youtube.com/@nexoscreator"
buttons:
  - name: "Website"
    url: "https://www.nexoscreator.tech"
  - name: "Youtube"
    url: "https://www.youtube.com/@nexoscreator"
```

### Configuration Options Explained

- **discord_token**: Your Discord user token.
- **application_id**: The Discord application ID to use for Rich Presence.
- **type**: Activity type (PLAYING, WATCHING, LISTENING, STREAMING, COMPETING).

## Web Interface

The add-on provides a web interface that can be accessed directly from your Home Assistant dashboard. This interface displays:

- Current Rich Presence status details
- The large and small images from your Discord Rich Presence
- Active buttons that link to your configured URLs
- Uptime information

The web interface automatically updates every 30 seconds to show the current status.
- **name**: Name of the activity.
- **details**: First line of Rich Presence.
- **state**: Second line of Rich Presence.
- **largeImageKey**: ID or URL of the large image.
- **largeImageText**: Text shown when hovering over the large image.
- **smallImageKey**: ID or URL of the small image.
- **smallImageText**: Text shown when hovering over the small image.
- **url**: URL for the activity (required for STREAMING type).
- **buttons**: Up to 2 buttons that can be added to your Rich Presence.

## How to Get Your Discord Token

Please note that sharing your Discord token or using it in unauthorized applications is against Discord's Terms of Service. This information is provided for educational purposes only.

## Support

If you have any issues with this add-on, please open an issue on the GitHub repository.

## Disclaimer

This add-on is for **educational use only**. Using selfbots or automating user accounts is against Discord's Terms of Service and may lead to account termination. Use at your own risk.