# ReviveAI - Release APK / AAB Build + Phone Install Guide (2026-06-10)

**Your Goal**: Build a proper **release** version (not debug), install it directly on your real phone (CPH2083), and test the full app.

## 1. Should You Switch to Real AdMob IDs Right Now?

**ANSWER: NO. Keep using the TEST AdMob IDs for now.**

### Why you should NOT switch yet:
- You are building for **direct sideloading** on your personal phone (not uploading to Play Store yet).
- Real AdMob IDs are meant for **published apps** (or apps in internal/closed testing tracks in Play Console).
- Using real production ad units in a sideloaded release build can cause:
  - Invalid traffic flags on your AdMob account
  - Poor ad fill rates / policy issues
  - Your real ad account getting warnings
- Test ads (`ca-app-pub-3940256099942544/...`) are **specifically designed** for exactly this situation: development, internal testing, sideloading, and pre-release verification.
- All previous project docs (NEXT_STEPS.md, PRD_GAP_ANALYSIS.md, ADMOB_SETUP.md) explicitly say:  
  **"Switch to your real ones only before final release."**

### When you SHOULD switch to real AdMob IDs:
- After you have a Google Play Console account
- After you upload the app to an Internal Testing track
- Right before you create the final public release build

**Current state in code** (already correct):
- `lib/services/ad_service.dart` uses **test IDs** in the active constants.
- Your real IDs are safely commented with the note "Replace these with your REAL ad unit IDs before publishing the app".

**Action**: Do **nothing** with AdMob IDs for this build.

---

## 2. Pre-Build Checklist (Do This on Your Windows PC)

On your local machine (`C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai`):

1. Make sure you have the latest code from this workspace (especially the recent History Save + Settings changes).
2. Open a terminal in the project folder.
3. Run these commands **in order**:

```bash
flutter clean
flutter pub get
```

4. (Recommended but optional for this test build) Regenerate icon + splash if you want nice visuals:
   ```bash
   flutter pub run flutter_launcher_icons
   # dart run flutter_native_splash:create     # only if you have the package enabled
   ```

5. **Check / fix package name** (very important for release builds)
   Open this file:
   `android/app/build.gradle.kts` (or `android/app/build.gradle` if using Groovy)

   Look for a line like:
   ```kotlin
   applicationId = "com.example.reviveai"   // or whatever it currently says
   ```

   Change it to something unique, e.g.:
   ```kotlin
   applicationId = "com.yourname.reviveai"     // or com.pmls.reviveai
   ```

   Also update the `package` in `AndroidManifest.xml` if needed (usually it matches).

6. (Optional but good) Create a release keystore (you only need to do this once):
   Follow the official guide or ask me for the exact commands if you want a simple one.

---

## 3. Build Commands (Run These)

### Option A: Build Release APK (what you asked for — easiest to install on phone)
```bash
flutter build apk --release
```

Output location:
`build\app\outputs\flutter-apk\app-release.apk`

### Option B: Also build App Bundle (recommended for future Play Store)
```bash
flutter build appbundle --release
```

Output:
`build\app\outputs\bundle\release\app-release.aab`

**I recommend running BOTH commands** (APK for immediate phone testing, AAB for later submission).

---

## 4. Install the APK on Your Real Phone (CPH2083)

1. Copy the `app-release.apk` file to your phone (via USB, Google Drive, etc.).
2. On your phone:
   - Go to **Settings → Security** (or **Apps → Special app access**)
   - Enable **"Install unknown apps"** or **"Install from unknown sources"** for your file manager / browser.
3. Open the APK file on your phone.
4. Tap **Install**.
5. After install, open the app.

**Note**: First launch may take a bit longer (release build optimization).

---

## 5. What to Test Immediately After Installing (Critical)

Use your real phone + the FAL key you created earlier.

### Must-test checklist:
- [ ] App icon looks good on home screen
- [ ] Splash screen appears with your custom assets (logo + background + "Restore Old Memories" branding)
- [ ] Go to Settings → paste your FAL key (`f3328d24-2198-47d9-ba11-e6517e693a18:cafaec7896d7f116a4cd12d6874552ae`) → Save FAL Key
- [ ] Switch AI Provider to **FAL** (it should already be default)
- [ ] Pick a photo → choose a mode (try Portrait Studio or Cartoon & Anime)
- [ ] Run enhancement → watch status messages
- [ ] On Result screen:
  - Before/After slider works
  - "Save to Gallery" button (or "Save Premium Quality" if you test premium)
  - Loading spinner appears while saving
  - Share button works
- [ ] History tab:
  - New result appears with thumbnail
  - Premium badge if you had premium status
  - Download (Save) button shows correct icon (workspace_premium for premium results)
  - Tap Save → confirmation dialog appears (premium-aware)
  - Actually saves to Gallery
- [ ] Free user experience:
  - Watermark appears on result ("ReviveAI Free")
  - Banner ad shows (test ad)
  - Daily limit message after 5 uses
- [ ] Premium simulation (temporary):
  - You can hardcode `isPremium = true` in `PurchaseService` or `AdService` for testing, or just note the UI labels
- [ ] Offline test: Turn off mobile data + WiFi → try to enhance → clear error message
- [ ] Settings → tap Privacy Policy and Terms → they open your Netlify pages in browser

---

## 6. After Testing — What to Do Next

Once the sideloaded release APK works well on your phone:

1. Tell me the results (any crashes, visual issues, FAL working, Save working, etc.).
2. We will decide:
   - Keep test ads for now (recommended)
   - Or switch to real ads + prepare for Play Console internal testing
3. Next big item is usually **real IAP setup** (your senior needs to handle Play Console `premium_unlock` product).

---

## Quick One-Liner Commands (Copy-Paste on Your PC)

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

flutter clean
flutter pub get

flutter build apk --release
flutter build appbundle --release
```

Then copy the APK from:
`build\app\outputs\flutter-apk\app-release.apk`

---

## Common Issues & Fixes

- **"Flutter command not found"** → Make sure Flutter is in your PATH (the one at `C:\Users\PMLS\...` or wherever you installed it).
- **Build fails with "package name" error** → Change `applicationId` as shown in step 5 above.
- **App icon or splash looks wrong** → Run the launcher_icons + native_splash commands before building.
- **"Debug banner" still shows** → You must use `--release` (not just `flutter build apk`).
- **Ads not showing** → Normal with test IDs on first runs. They can take time to load.
- **FAL not working** → Make sure you saved the key in Settings and selected FAL provider.

---

## Files You Should Have Locally Before Building

Make sure these are up to date from the workspace:
- `lib/screens/history_screen.dart`
- `lib/screens/settings_screen.dart`
- `lib/services/ai_provider_service.dart`
- `lib/services/ad_service.dart` (keep test IDs)
- `pubspec.yaml`
- `assets/images/` folder (all 4 splash/icon images)

---

**Ready?**

Run the commands above on your Windows machine, install the APK on your CPH2083 phone, and test thoroughly.

Then reply here with:
- "Build succeeded, APK installed, testing results are: [list what worked / what didn't]"
- Or paste any error you get during `flutter build`.

I will guide you through fixes or the next step (real AdMob switch decision, IAP prep, etc.).

You are very close to having a real, installable production-style build on your phone. Let's do this cleanly.