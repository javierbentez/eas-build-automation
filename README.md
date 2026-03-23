# 🚀 Expo & EAS Build Automator

A professional suite of scripts to streamline your **Expo** and **EAS Build** workflow. Forget about complex flags or manual cleanup—these scripts handle dependency installation, git synchronization, prebuilding, and deployment in one interactive flow.

---

## ✨ Key Features

* **Multi-Platform Support:** Includes native scripts for **macOS/Linux** (Bash) and **Windows** (PowerShell).
* **Interactive Menus:** Easy selection of platforms (`iOS`, `Android`, `All`) and profiles (`Development`, `Preview`, `Production`).
* **Smart Build Routing:** Toggle between **Local** builds (save cloud credits!) or **EAS Cloud**.
* **Fail-Safe Execution:** Scripts stop immediately if a critical step (like `npm install`) fails.
* **Git Sync:** Automatically pulls the latest code and offers to clear local conflicts if needed.
* **Production Ready:** Automatically triggers `--auto-submit` when the production profile is selected.
* **Clean Prebuild:** Runs `expo prebuild --clean` to ensure a fresh native environment.

---

## 📋 Prerequisites

Before running the scripts, ensure you have:

* [Node.js & NPM](https://nodejs.org/)
* [Git](https://git-scm.com/)
* [EAS CLI](https://docs.expo.dev/build/setup/): `npm install -g eas-cli`
* An existing Expo project with a valid `eas.json`.

---

## 🚀 Setup & Usage

### For macOS and Linux (Bash)

1.  **Create the file**: `expo-build.sh` in your project root.
2.  **Paste the Bash code** into the file.
3.  **Make it executable**:
    ```bash
    chmod +x expo-build.sh
    ```
4.  **Run it**:
    ```bash
    ./expo-build.sh
    ```

### For Windows (PowerShell)

1.  **Create the file**: `expo-build.ps1` in your project root.
2.  **Paste the PowerShell code** into the file.
3.  **Set Execution Policy** (if you haven't already):
    Open PowerShell as Administrator and run:
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```
4.  **Run it**:
    ```powershell
    ./expo-build.ps1
    ```

---

## 🛠 Workflow Logic

| Step | Behavior |
| :--- | :--- |
| **Dependency Check** | Verifies if `git`, `npm`, and `eas` are installed. |
| **Git Pull** | Syncs with remote. If conflicts exist, it asks to `git checkout .` to proceed. |
| **Dependencies** | Runs `npm install` to keep packages up to date. |
| **Prebuild** | Cleans native folders (`/ios`, `/android`) to avoid cache issues. |
| **iOS Validation** | **(Windows Only)** Prevents local iOS builds as they require Xcode/macOS. |
| **Auto-Submit** | Enabled automatically **only** for the `production` profile. |

---

## ⚠️ Important Notes

* **Local iOS Builds:** Require a **macOS** machine with **Xcode** installed.
* **EAS Login:** Ensure you are logged in (`eas login`) before starting cloud builds.
* **Local Android Builds:** Require **Android Studio** and `ANDROID_HOME` env variables configured.

---

**Tip:** Add these scripts to your `.gitignore` if you prefer, or commit them to your repository to standardize the build process for your entire team!
