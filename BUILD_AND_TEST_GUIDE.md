# Build & Test Guide - After flutter build apk --release

## Current Status (Good!)

You have successfully:
- Fixed pubspec.yaml (no more duplicate http)
- Generated app icons (✓ Successfully generated launcher icons)
- Applied manual splash (images copied + styles.xml updated)
- Run `flutter clean` + `flutter pub get`

Now you are running:
```bash
flutter build apk --release
```

This is the **correct next command**.

---

## What to Expect

The build can take **2–10 minutes** (sometimes longer on first release build).

You will see lines like:
- `Running Gradle task 'assembleRelease'...`
- Various `[        ]` progress lines
- At the end, something like:
  ```
  ✓ Built build/app/outputs/flutter-apk/app-release.apk (XX.XMB)
  ```

If it succeeds without red errors, great!

---

## After the Build Finishes (Important Commands)

Once the build completes successfully, run these:

```bash
# 1. Build the App Bundle too (for Play Store later)
flutter build appbundle --release

# 2. (Optional but recommended) List the output files
dir build\app\outputs\flutter-apk
dir build\app\outputs\bundle\release
```

---

## Install on Your Phone (CPH2083)

1. Copy the file:
   `build\app\outputs\flutter-apk\app-release.apk`

   to your phone (via USB, Google Drive, WhatsApp, etc.).

2. On your phone:
   - Go to **Settings → Security** (or search "Install unknown apps")
   - Allow your file manager / browser to install unknown apps.
   - Tap the APK → **Install**.
   - **Important**: Uninstall any previous version of "ReviveAI" first if it exists.

3. Open the newly installed app.

---

## Testing Checklist (Do This on Your Real Phone)

### Visuals (Most Important Right Now)
- [ ] **App Icon**: On home screen / app drawer, does it show your custom professional icon (not the default Flutter one)?
- [ ] **Splash Screen**: When you launch the app, do you immediately see your custom background (`splash_background.png`) + centered ReviveAI logo (`splash_logo.png`)?
- [ ] Splash disappears cleanly after a second or two and shows the main Enhance screen.

### Core Functionality
- [ ] Go to **Settings**
  - Paste your FAL key: `f3328d24-2198-47d9-ba11-e6517e693a18:cafaec7896d7f116a4cd12d6874552ae`
  - Tap "Save FAL Key"
  - Make sure FAL is selected as the provider (it should be default)

- [ ] Go to **Enhance** tab
  - Select a photo
  - Choose a mode (try "Portrait Studio" or "Old Photo Restore")
  - Tap "Enhance Photo with AI"
  - Watch for status messages (should use FAL)

- [ ] On **Result Screen**
  - Before/After slider works
  - "Save to Gallery" button works (with loading spinner)
  - Check if you see "ReviveAI Free" watermark (if not premium)

- [ ] Go to **History**
  - Your result appears with thumbnail
  - Tap the download / save button
  - You should see a **confirmation dialog** ("Save to Gallery?" or "Save Premium Quality?")
  - After confirming, it should save to your phone Gallery

### Other Quick Checks
- [ ] Turn off internet → try to enhance → you get a clear offline message
- [ ] Settings → tap Privacy Policy and Terms → they open in browser (your Netlify links)

---

## If the Build Fails

Paste the last 30–40 lines of the error here.

Common quick fixes:
- Run `flutter clean` again then `flutter pub get` then retry build.
- Make sure you have the latest `flutter create .` if Android folder issues appear.

---

## After You Test on Phone

Reply with a short report like:

**"Build succeeded + installed"**

Then list:
- Icon: updated ✓
- Splash: working ✓
- FAL enhancement: worked / failed
- History Save: confirmation dialog appeared ✓
- Any issues: ...

---

## Recommended: Enable Developer Mode (Fixes Warning)

You keep seeing:
> Building with plugins requires symlink support. Please enable Developer Mode...

Do this once on your Windows PC:
1. Press `Win + R`
2. Type and run:
   ```
   start ms-settings:developers
   ```
3. Turn **ON** "Developer mode"
4. Restart your PC (or at least the terminal)

This makes future builds cleaner and more reliable.

---

## Full Command Reference (for reference)

```bash
# After any change
flutter clean
flutter pub get

# Icon
flutter pub run flutter_launcher_icons

# Release builds
flutter build apk --release
flutter build appbundle --release
```

---

You are very close to a working release build with custom icon + splash.

Let the current `flutter build apk --release` finish, then report back with the result!