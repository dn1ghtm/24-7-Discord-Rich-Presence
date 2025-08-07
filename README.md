# Discord 24/7 Rich Presence

> Keep your Discord account **online 24/7** with custom **Rich Presence**!. Show games, music, or any activity—even when you're AFK. Lightweight and simple to use!
>
> Now available as a **Home Assistant add-on**!

![Preview](./assets/1688311925824.webp)

---

## 🚀 Features

- ✅ Stay **online 24/7** on Discord
- 🧠 Show **custom Rich Presence** (game titles, status, timestamps)
- 💻 Cross-platform: **Windows, macOS, Linux**
- 🏠 Available as a **Home Assistant add-on**
- 🔒 Lightweight and safe (no automation/selfbot)
- ⚙️ Configurable via JSON file or Home Assistant UI
- 🖼️ Web interface with image display on Home Assistant dashboard
- 🔄 Real-time status monitoring with automatic updates

---

## 🛠️ Setup

### Option 1: As a Home Assistant Add-on

1. **Add the repository to your Home Assistant instance**

   - Go to Settings -> Add-ons -> Add-on Store
   - Click the menu in the top right corner
   - Select "Repositories"
   - Add this repository URL: `https://github.com/your-username/discord-24-7-rich-presence`
   - Click "Add"

2. **Install the add-on**

   - Find "Discord 24/7 Rich Presence" in the add-on store
   - Click "Install"

3. **Configure the add-on**

   - Enter your Discord token and customize your Rich Presence settings
   - Save the configuration

4. **Start the add-on**

   - Toggle the "Start" switch to run the add-on

5. **Access the web interface**

   - The add-on will appear on your Home Assistant dashboard
   - Click on the Discord icon to open the web interface
   - View your Rich Presence status, images, and buttons in real-time

### Option 2: Standalone Installation

1. **Clone the repo**

```bash
git clone https://github.com/nexoscreation/discord-24-7-rich-presence.git
cd discord-24-7-rich-presence
```

2. **Install dependencies**

```bash
npm install
```

3. **Edit your config**

- Open `.env` and set your account token.

```env
TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

- Open `config.json` and set your Rich Presence data.

4. **Run the code**

```bash
npm run start
```

---

## 🔧 Example `config.json`

```json
{
  "application_id": "YOUR_DISCORD_APP_ID",
  "type": "STREAMING",
  "details": "Streaming on YouTube 🎥",
  "state": "Live 24/7 🚀",
  "largeImageKey": "yt_logo",
  "largeImageText": "YouTube",
  "smallImageKey": "online",
  "smallImageText": "Always Online",
  "buttons": [
    {
      "name": "Watch Live",
      "url": "https://youtube.com/yourchannel"
    }
  ]
}
```

---

## 🤝 Contributing

We ❤️ contributions! Follow these steps to contribute:

1. 🍴 **Fork** the repository
2. 🌿 **Create** a new branch (`git checkout -b feature/AmazingFeature`)
3. 💾 **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. 🚀 **Push** to the branch (`git push origin feature/AmazingFeature`)
5. 🔃 **Open a Pull Request**

---

## ❗ Disclaimer

This is for **educational use only**. Misuse can lead to **Discord account restrictions**. Avoid using user tokens or automating user actions.

---

## 📄 License

This project is licensed under **The UnLicense** See the [LICENSE](LICENSE) file for details.

---

## 📬 Contact & Community

💬 Join us on **Discord**: [Click Here](https://discord.gg/H7pVc9aUK2)  
🐦 **Follow on Twitter**: [@nexoscreation](https://twitter.com/nexoscreation)  
📧 **Email**: [contact@nexoscreation.tech](mailto:contact@nexoscreation.tech)

<p align="center">
  Made with ❤️ by <a href="https://github.com/nexoscreation">@nexoscreation</a>
</p>
