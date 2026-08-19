[Перейти на русский](README_RU.md)

<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&text=CruiseControlBlitz&height=200&fontSize=60&fontAlignY=40&desc=For%20Tanks%20Blitz&descAlignY=60" />
</p>#CruiseControlBlitz

**Cruise control for World of Tanks Blitz and Tanks Blitz** – a tool that lets you assign separate keys for forward and backward movement, so your tank keeps driving without holding buttons.

---

## 📋 Table of Contents

- [Features](#-features)
- [Download](#-download)
- [Usage](#-usage)
- [Building from source](#-building-from-source)
- [Technologies](#-technologies)
- [Support](#-support)
- [License](#-license)

---

## 🔥 Features

- 🎮 **Assign any keys** – supports combinations with `Ctrl`, `Alt`, `Shift`, `Win`.
- 💾 **Settings are saved** in `Documents\CruiseControl\cruise_settings.ini`.
- 🚫 **W and S are not intercepted** – they work as usual in the game.
- ⚡ **No installation required** – single `.exe` file.
- 🔄 **Emergency stop** – by pressing the «Stop» key.

---

## 📥 Download

Go to **[Releases](https://github.com/fe0mpl/CruiseControlBlitz/releases)** and download the latest `CruiseControl.exe`.

---

## 🛠 Usage

1. **Run** `CruiseControl.exe` (preferably **as administrator**).
2. **Bind keys**:
   - Click the «Forward» button → press the key you want (e.g., `W` or `Ctrl+W`).
   - Repeat for «Backward» and «Stop».
   - If you change your mind, press `Esc` to cancel.
3. **Enable cruise control**:
   - Click the green «Enable» button – it turns red with «Disable» text.
4. **In game**:
   - Press the assigned forward key – the tank drives forward until you press the same key again (stop).
   - Same for backward.
   - Press the «Stop» key for an emergency stop.
   - The `W` and `S` keys work normally – they don't interfere with the cruise.

---

## 🔧 Building from source

If you want to build the program yourself:

### Requirements
- Windows 7 / 8 / 10 / 11
- [AutoHotkey v1](https://www.autohotkey.com/)

### Instructions
1. Install AutoHotkey v1.
2. Save `CruiseControl.ahk` with **UTF‑8 with BOM** encoding.
3. Run `Ahk2Exe` (included with AutoHotkey) and compile `.ahk` to `.exe`.

---

## 🧰 Technologies

- **AutoHotkey v1** – scripting language for Windows utilities.
- **Windows API** – for key interception and GUI.

---

## 💖 Support

If you like the program – give it a ⭐ star on GitHub to help other players find it.

---

## ⚖️ License

This project is distributed under the **MIT License**. See the `LICENSE` file for details.

---

## 📝 Changelog

### v1.0 – 2026-08-19
- Initial stable release.
- Basic features: key binding, cruise control, settings saving.
