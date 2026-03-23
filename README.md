# 🚀 Expo & EAS Build Automator

A robust Bash script to streamline your **Expo** and **EAS Build** workflow. Forget about typing long commands or forgetting flags—this script handles dependency installation, git synchronization, prebuilding, and deployment in one interactive flow.

---

## ✨ Features

* **Interactive Menus:** Easy selection of platforms (`iOS`, `Android`, `All`) and profiles (`Development`, `Preview`, `Production`).
* **Smart Build Routing:** Choose between **Local** builds (to save cloud credits!) or **EAS Cloud**.
* **Fail-Safe Execution:** Uses `set -e` to stop immediately if any step (like `npm install`) fails.
* **Git Sync:** Automatically pulls the latest code and offers to clear local conflicts if needed.
* **Production Ready:** Automatically triggers `--auto-submit` when the production profile is selected.
* **Clean Prebuild:** Runs `expo prebuild --clean` to ensure no stale native artifacts interfere with your build.

## 📋 Prerequisites

Before running the script, ensure you have the following installed:

* [Node.js & NPM](https://nodejs.org/)
* [Git](https://git-scm.com/)
* [EAS CLI](https://docs.expo.dev/build/setup/): `npm install -g eas-cli`
* An existing Expo project with a valid `eas.json` configuration.

## 🚀 Quick Start

1.  **Create the script file** in your project's root directory:
    ```bash
    touch expo-build.sh
    ```

2.  **Paste the script code** into the file and save it.

3.  **Make it executable**:
    ```bash
    chmod +x expo-build.sh
    ```

4.  **Run it**:
    ```bash
    ./expo-build.sh
    ```

## 🛠 Workflow Logic

The script automates the following steps to ensure a reliable build:

| Step | Behavior |
| :--- | :--- |
| **Git Pull** | Attempts a pull. If conflicts exist, it asks to `git checkout .` to sync. |
| **Dependencies** | Runs `npm install` to ensure your packages are up to date. |
| **Prebuild** | Cleans native folders (`/ios`, `/android`) before building to avoid caching issues. |
| **Auto-Submit** | Automatically activated **only** when selecting the `production` profile. |
| **Local Builds** | Adds the `--local` flag if you choose to build on your machine. |

## ⚠️ Important Notes

* **Local iOS Builds:** If you choose a local build for iOS, you must be running the script on a **macOS** machine with **Xcode** properly configured.
* **EAS Login:** Ensure you have logged in to your Expo account via terminal using `eas login` before running the script for cloud builds.

---

**Tip:** You can add this script to your `.gitignore` if you don't want to track it, or keep it in the repo so your whole team can use the same standardized build process!
