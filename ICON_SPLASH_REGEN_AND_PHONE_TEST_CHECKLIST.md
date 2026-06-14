# ReviveAI - Exact Commands: Regenerate App Icon + Splash + Full Phone Test (CPH2083)

**Date**: 2026-06-10  
**Target**: Your local Windows machine + real phone (CPH2083)  
**Goal**: Get proper professional app icon + splash screen in a **release build**, then thoroughly test the latest features (including the recent History Save changes + simplified Settings).

---

## IMPORTANT: All Commands Run on YOUR Windows PC

The Arena workspace has a broken Flutter installation.  
You **must** do this on your laptop at:  
`C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai`

Open **Command Prompt** or **PowerShell** and `cd` into that folder before running anything.

---

## Step 1: Prepare Your Local Project (Do This First)

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

flutter clean
flutter pub get
```

This ensures you have the latest code (History premium Save button, confirmation dialog, FAL-focused Settings, etc.).

---

## Step 2: Regenerate App Icon (Easy & Recommended)

The `flutter_launcher_icons` package is still active in your `pubspec.yaml`.

### Exact commands:
```bash
flutter pub run flutter_launcher_icons
```

### What this does:
- Takes `assets/images/app_icon.png`
- Generates all required launcher icons for Android (including adaptive icon with blue background `#1565C0`)
- Puts them into `android/app/src/main/res/mipmap-*` folders

**Expected output**: You should see messages like "✓ Successfully generated launcher icons"

**Verify** (optional but good):
Open this folder on your PC:
`android/app/src/main/res/`
You should now see folders like `mipmap-hdpi`, `mipmap-mdpi`, `mipmap-xhdpi`, etc. with `ic_launcher.png` and `ic_launcher_foreground.png` etc.

---

## Step 3: Splash Screen — TWO OPTIONS (Choose One)

**Critical Note**: `flutter_native_splash` is currently **commented out** in `pubspec.yaml` because of the bug you experienced earlier ("type 'bool' is not a subtype...").

### Option A: Manual Splash (Recommended & Safest — No Package Needed)

This is the method we prepared earlier (see `INSTRUCTIONS_MANUAL_SPLASH.md`).

**Exact steps**:

1. Create the drawable folder if missing:
   ```bash
   mkdir -p android/app/src/main/res/drawable
   ```

2. Copy the splash images from assets to drawable:
   ```bash
   copy assets\images\splash_background.png android\app\src\main\res\drawable\
   copy assets\images\splash_logo.png android\app\src\main\res\drawable\
   ```

3. Create the splash layer list file.

   Create this new file:
   `android/app/src/main/res/drawable/splash.xml`

   Paste **exactly** this content:

   ```xml
   <?xml version="1.0" encoding="utf-8"?>
   <layer-list xmlns:android="http://schemas.android.com/apk/res/android">
       <!-- Background -->
       <item android:drawable="@drawable/splash_background" />

       <!-- Centered logo -->
       <item>
           <bitmap
               android:gravity="center"
               android:src="@drawable/splash_logo" />
       </item>
   </layer-list>
   ```

4. Update the launch theme.

   Open this file:
   `android/app/src/main/res/values/styles.xml`

   Find the `LaunchTheme` style and make sure it contains:
   ```xml
   <style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
       <item name="android:windowBackground">@drawable/splash</item>
       <!-- other items can stay -->
   </style>
   ```

   (If the file has a messy/duplicated version from before, replace the whole `LaunchTheme` block with the above.)

   For Android 12+ (your phone is Android 9, but good to have):
   Create or edit `android/app/src/main/res/values-v31/styles.xml` with similar content.

5. After manual changes, always run:
   ```bash
   flutter clean
   flutter pub get
   ```

This gives you a reliable custom splash using your `splash_background.png` + centered `splash_logo.png`.

### Option B: Try the Package Again (Only If You Want Branding Image at Bottom)

If you want to use the branding image (`splash_branding.png`) at the bottom, you can try re-adding the package temporarily.

**Commands**:
```bash
# 1. Add the package back temporarily
flutter pub add flutter_native_splash

# 2. Run the generator
dart run flutter_native_splash:create

# 3. (After testing) Remove it again if it causes problems
# flutter pub remove flutter_native_splash
```

Your `flutter_native_splash.yaml` already has the correct branding config:
```yaml
background_image: assets/images/splash_background.png
branding: assets/images/splash_branding.png
branding_mode: bottom
```

**Recommendation**: Start with **Option A (Manual)**. It is more reliable on your machine.

---

## Step 4: Full Release Build (APK + AAB)

After icon + splash steps above, run:

```bash
flutter clean
flutter pub get

# Release APK (for direct install on your phone)
flutter build apk --release

# Also build App Bundle (for Play Store later)
flutter build appbundle --release
```

**Output files**:
- APK: `build\app\outputs\flutter-apk\app-release.apk`
- AAB: `build\app\outputs\bundle\release\app-release.aab`

---

## Step 5: Install on Your Real Phone (CPH2083)

1. Connect your phone via USB (or copy the APK via any method).
2. On the phone:
   - Go to **Settings > Security** (or search "unknown sources" / "install unknown apps").
   - Allow installation from your file manager / browser.
3. Open the `app-release.apk` file → Install.
4. Open the newly installed **ReviveAI** app.

**Tip**: After installing a release build, you may want to uninstall any previous debug version first to avoid conflicts.

---

## Step 6: Full Testing Checklist on Your CPH2083 Phone

Test **in this order**. Mark each item as you go.

### A. Visuals (First Launch)
- [ ] App icon on home screen / app drawer looks professional (not default Flutter icon)
- [ ] Splash screen appears immediately on launch with your custom background + ReviveAI logo (centered or with branding)
- [ ] Splash disappears cleanly and goes to the Enhance tab

### B. Settings Screen (FAL-Focused Changes)
- [ ] Open Settings tab
- [ ] AI Provider dropdown shows **FAL** selected by default with green "RECOMMENDED" badge
- [ ] Big prominent card right below is **"FAL AI API Key"** (with flash icon)
- [ ] Paste your real FAL key exactly:
  `f3328d24-2198-47d9-ba11-e6517e693a18:cafaec7896d7f116a4cd12d6874552ae`
- [ ] Tap "Save FAL Key" → see success snackbar
- [ ] "Advanced (Replicate + Proxy Fallback)" section is collapsed (tap to expand — Replicate and Proxy fields should be smaller/less prominent)
- [ ] Tap Privacy Policy and Terms of Service → they open your Netlify pages in the browser:
  - Privacy: https://idyllic-pothos-cce5d7.netlify.app
  - Terms: https://golden-trifle-504c14.netlify.app

### C. Enhancement Flow (with Real FAL)
- [ ] Go to Enhance tab
- [ ] Select a photo (use an old/damaged one for best test)
- [ ] Choose modes — especially the new ones:
  - Portrait Studio
  - Cartoon & Anime
- [ ] Tap Enhance → see real processing status messages ("Uploading to FAL AI...", etc.)
- [ ] Result screen appears with working Before/After slider
- [ ] See subtle "Premium Quality" indicator only if you have premium (or test both states)

### D. Save to Gallery (Real gal implementation + Recent Changes)
- [ ] On Result screen:
  - Tap the big save button
  - See loading indicator (CircularProgressIndicator) while saving
  - Button text/icon should be "Save to Gallery" + download icon (or "Save Premium Quality" + workspace_premium if premium)
  - Success green snackbar "Saved to Gallery successfully!"
- [ ] Go to phone's Gallery app → confirm the photo is there (no watermark if premium, watermark if free)

### E. History Tab — New Premium-Aware Save Features
- [ ] History tab shows your recent enhancements with thumbnails
- [ ] For a **normal (free) result**:
  - Trailing button shows normal **download icon**
  - Tooltip says "Save to Gallery"
- [ ] For a **Premium result** (if you have any, or temporarily note the UI):
  - Trailing button shows **gold workspace_premium icon**
  - Tooltip says "Save Premium Quality"
- [ ] Tap the Save (download/premium) button in History list:
  - **Confirmation dialog appears** before saving
  - Dialog title is "Save Premium Quality?" (for premium items) or "Save to Gallery?" (for free)
  - Content explains what will be saved
  - Tap "Save" in dialog → proceeds to real save (permission + Gal.putImage)
- [ ] Delete works with confirmation dialog (already existed)
- [ ] Tap any history item → opens in Result screen with slider

### F. Premium vs Free Differentiation
- [ ] Free user sees:
  - Watermark "ReviveAI Free" on result
  - Test banner ad at bottom of Result screen
  - Daily limit message after 5 uses
- [ ] Premium labels appear correctly in Enhance cards, Result screen, and History
- [ ] Batch button is visible only for premium (or note the UI)

### G. Other Important Tests
- [ ] Offline test:
  - Turn off WiFi + mobile data
  - Try to enhance → clear red warning "No internet connection..."
- [ ] Share button works (opens share sheet)
- [ ] Delete from Result or History works
- [ ] App feels snappy (release build should be faster than debug)

---

## Step 7: After Testing — What to Tell Me

Run the full checklist on your real CPH2083 phone.

Then reply here with something like:

**"Icon + splash regenerated + release APK installed. Testing results:"**

Then list:
- What worked perfectly
- Any issues (e.g. "Splash still default", "FAL key saved but enhancement failed with ...", "History Save confirmation worked", "No watermark on free results", etc.)
- Screenshots if possible (especially splash + History Save button + Result save button)

---

## Bonus: One-Command Sequence (Copy-Paste)

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

flutter clean
flutter pub get

flutter pub run flutter_launcher_icons

# === MANUAL SPLASH (recommended) ===
mkdir -p android\app\src\main\res\drawable
copy assets\images\splash_background.png android\app\src\main\res\drawable\
copy assets\images\splash_logo.png android\app\src\main\res\drawable\

# (Now manually create splash.xml and update styles.xml as described above)

flutter clean
flutter pub get

flutter build apk --release
flutter build appbundle --release
```

---

## Files That Should Already Be Correct in Your Local Folder
- `flutter_launcher_icons.yaml`
- `assets/images/app_icon.png`, `splash_logo.png`, `splash_background.png`, `splash_branding.png`
- `lib/services/ad_service.dart` (still using **test** AdMob IDs — correct for now)
- Latest `history_screen.dart` and `settings_screen.dart` (for the Save button + Settings changes)

---

This is the exact, step-by-step process for **Option A**.

Do the commands, install the APK, run the testing checklist, and report back.

Once we confirm icon/splash + basic flow work on your real phone, the next logical step will be either:
- Preparing for real AdMob switch + Play Console testing, or
- Real IAP product creation instructions for your senior.

Let me know when you start and what results you get!