# ReviveAI - Exact Commands for App Icon + Splash Screen (Windows PC)

**Target Machine**: Your local Windows laptop  
**Path**: `C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai`

**Goal**: Generate proper professional app icon and a custom splash screen for the release build.

---

## Step 0: Preparation (Run First)

Open **Command Prompt** or **PowerShell** and run:

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

flutter clean
flutter pub get
```

---

## Step 1: Generate App Icon (Recommended)

The `flutter_launcher_icons` package is still active in your `pubspec.yaml`.

### Exact Command:

```bash
flutter pub run flutter_launcher_icons
```

### What this does:
- Uses `assets/images/app_icon.png`
- Creates adaptive icon with blue background (`#1565C0`)
- Generates all density folders in `android/app/src/main/res/mipmap-*`

**Expected output**: You should see messages like:
```
✓ Successfully generated launcher icons for Android
```

### Verify (optional):
Open this folder in File Explorer:
`android\app\src\main\res\`

You should now see folders like `mipmap-hdpi`, `mipmap-xhdpi`, etc. containing the generated icons.

---

## Step 2: Splash Screen — Recommended Method (Manual)

**Important**: We are using the **Manual splash method** because `flutter_native_splash` had persistent bugs on your machine earlier.

This method is reliable and uses your custom images.

### Exact Commands + Manual Steps:

1. **Create the drawable folder** (if it doesn't exist):

```bash
mkdir -p android\app\src\main\res\drawable
```

2. **Copy the splash images** from assets to Android resources:

```bash
copy assets\images\splash_background.png android\app\src\main\res\drawable\
copy assets\images\splash_logo.png android\app\src\main\res\drawable\
```

3. **Create the splash layer-list file** (`splash.xml`):

Create a new file at this exact path:
`android\app\src\main\res\drawable\splash.xml`

**Paste the following exact content** into it:

```xml
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Full background image -->
    <item android:drawable="@drawable/splash_background" />

    <!-- Centered ReviveAI logo -->
    <item>
        <bitmap
            android:gravity="center"
            android:src="@drawable/splash_logo" />
    </item>
</layer-list>
```

4. **Update the Launch Theme** (most important step):

Open this file:
`android\app\src\main\res\values\styles.xml`

Find the `LaunchTheme` style and **replace** it with this (or add the line if missing):

```xml
<style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
    <!-- Show custom splash immediately -->
    <item name="android:windowBackground">@drawable/splash</item>
</style>
```

**Note**: If the file looks messy or has duplicate LaunchTheme entries (from previous attempts), clean it up and keep only the version above.

**Optional but recommended** (for Android 12+ devices):

Create this file if it doesn't exist:
`android\app\src\main\res\values-v31\styles.xml`

And paste:

```xml
<style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
    <item name="android:windowBackground">@drawable/splash</item>
    <item name="android:windowSplashScreenBackground">#1565C0</item>
</style>
```

5. **Final cleanup**:

```bash
flutter clean
flutter pub get
```

---

## Step 3: Build Release APK + AAB (After Icon + Splash)

```bash
flutter build apk --release
flutter build appbundle --release
```

**Output locations**:
- APK: `build\app\outputs\flutter-apk\app-release.apk`
- AAB: `build\app\outputs\bundle\release\app-release.aab`

---

## Full One-Command Sequence (Copy-Paste All)

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

flutter clean
flutter pub get

# === Fix Android folder if needed (safe command) ===
flutter create .

flutter clean
flutter pub get

# === 1. App Icon ===
flutter pub run flutter_launcher_icons

# === 2. Manual Splash (Recommended) ===
mkdir -p android\app\src\main\res\drawable

copy assets\images\splash_background.png android\app\src\main\res\drawable\
copy assets\images\splash_logo.png android\app\src\main\res\drawable\

# (Now manually create splash.xml and edit styles.xml as shown above)

flutter clean
flutter pub get

# === 3. Build Release Versions ===
flutter build apk --release
flutter build appbundle --release
```

---

## Alternative: Try flutter_native_splash Package (Only If You Want Branding at Bottom)

If you want to use `splash_branding.png` at the bottom, you can try adding the package temporarily:

```bash
# Add the package
flutter pub add flutter_native_splash

# Run the generator (uses your flutter_native_splash.yaml)
dart run flutter_native_splash:create

# After testing, you can remove it again:
# flutter pub remove flutter_native_splash
```

**Note**: Only do this if the manual method doesn't satisfy you. The manual method (above) is safer on your machine.

---

## Verification on Your Phone (After Installing the APK)

1. Install the new `app-release.apk` on your CPH2083 phone.
2. Uninstall any previous debug version first (recommended).
3. Launch the app:
   - You should see your custom splash screen immediately (background + centered ReviveAI logo).
   - App icon on the home screen should be the professional one (not the default Flutter icon).

---

## Files You Need Locally

Make sure these exist in your project before running the commands:

- `assets/images/app_icon.png`
- `assets/images/splash_logo.png`
- `assets/images/splash_background.png`
- `flutter_launcher_icons.yaml` (already configured)
- `pubspec.yaml` (has `flutter_launcher_icons` in dev_dependencies)

---

## Common Issues & Fixes

| Problem | Solution |
|---------|----------|
| App icon doesn't change | Run `flutter clean` + `flutter pub get` after the icons command |
| Splash still shows default white | Make sure you edited `styles.xml` correctly and ran `flutter clean` |
| "No such file" errors | Run the `mkdir` and `copy` commands exactly as shown |
| Want bigger/smaller logo | Edit `splash.xml` and change gravity or add scale |
| Want branding text at bottom | Try the `flutter_native_splash` package method above |

---

## Full Detailed Guide

For screenshots, explanations, and troubleshooting, read the full document in your project:

**`ICON_SPLASH_REGEN_AND_PHONE_TEST_CHECKLIST.md`**

Also see the older detailed manual splash instructions:
**`INSTRUCTIONS_MANUAL_SPLASH.md`**

---

## After Successful Icon + Splash

Once the new release APK shows the correct icon and splash on your phone, we can move to:

- Final testing of the modern UI
- Decision on real AdMob IDs
- Preparing the App Bundle for your senior + Play Console IAP work

Run the commands above and report back with results!