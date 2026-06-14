# FINAL: Build Complete + Phone Testing Guide

## Current Situation

You ran:
- `flutter build apk --release`
- `flutter build appbundle --release`

You are seeing a **Kotlin version warning** (1.8.22). This is **not an error** — it is a future deprecation warning from Flutter. The build is still running ("Running Gradle task 'bundleRelease'...").

---

## Step 1: Wait for the Build to Finish

The App Bundle build can take several minutes.

When it succeeds, you should see something like:

```
✓ Built build/app/outputs/bundle/release/app-release.aab (XX.XMB)
```

If it succeeds without red "FAILURE" or "Build failed" messages, you are good.

---

## Step 2: Quick Kotlin Warning Fix (Recommended – Do This After Build)

The warning says support for Kotlin 1.8.22 will be dropped soon.

### Simple Fix:

Open this file:
`android/settings.gradle`

Add or update the plugins block at the top like this:

```gradle
plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.1.0" apply false
    id "org.jetbrains.kotlin.android" version "1.9.22" apply false   // ← Upgrade to at least 1.9.22 or 2.0+
}
```

Then save and rebuild later if needed. For now, we can ignore it and continue.

---

## Step 3: Locate Your Release Files

After both builds finish, check these folders:

**APK (for direct phone install):**
`build\app\outputs\flutter-apk\app-release.apk`

**App Bundle (for Play Store / testing track):**
`build\app\outputs\bundle\release\app-release.aab`

---

## Step 4: Ensure Manual Splash is Fully Applied (Critical)

You copied the images. Now make sure this file exists:

**Create this file if it doesn't exist:**

Path:  
`android\app\src\main\res\drawable\splash.xml`

Paste exactly:

```xml
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@drawable/splash_background" />
    <item>
        <bitmap
            android:gravity="center"
            android:src="@drawable/splash_logo" />
    </item>
</layer-list>
```

You already updated `styles.xml` with the correct `LaunchTheme` pointing to `@drawable/splash` — that's good.

---

## Step 5: Install on Your Phone (CPH2083)

1. Copy `app-release.apk` to your phone.
2. **Uninstall** any previous version of ReviveAI.
3. Install the new APK.
4. Open the app.

---

## Step 6: Testing Checklist (Focus on What You Asked About)

### Visuals (Icon + Splash) — Priority #1
- [ ] **App Icon**: On your home screen / app drawer — does it show the professional custom icon (not default Flutter)?
- [ ] **Splash Screen**: When launching the app, do you see your custom background image + centered ReviveAI logo immediately?
- [ ] Splash disappears cleanly and shows the Enhance screen.

### Core Functionality (Quick Smoke Test)
- [ ] Settings → Paste your FAL key (`f3328d24-2198-47d9-ba11-e6517e693a18:cafaec7896d7f116a4cd12d6874552ae`) → Save FAL Key
- [ ] Try one enhancement (e.g. Portrait Studio or Old Photo Restore)
- [ ] On Result screen: "Save to Gallery" button shows loading spinner while saving
- [ ] Go to History:
  - Tap the Save button on a history item
  - You should see a **confirmation dialog** ("Save to Gallery?" or "Save Premium Quality?")
  - After confirming, the image should appear in your phone's Gallery app

### Bonus Checks
- Watermark appears on free results ("ReviveAI Free")
- Before/After slider works
- Settings → Legal links open your Netlify pages

---

## Step 7: Report Back

After you install and test, reply with a short status:

**Example good reply:**
"Build succeeded.  
- App icon updated ✓  
- Splash working with background + logo ✓  
- FAL enhancement worked  
- History Save confirmation dialog appeared ✓  
- Saved to Gallery successfully"

Or tell me any problems (e.g. "Splash still default", "Build failed with this error...", "Icon not updated").

---

## Quick Rebuild Command (if you need to rebuild after fixing splash.xml)

```bash
flutter clean
flutter pub get
flutter build apk --release
```

---

You are at the final testing stage.

Let the current `bundleRelease` finish, then follow the steps above and report the results on your real phone. 

I'm ready when you paste the outcome!