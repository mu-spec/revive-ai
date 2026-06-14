# ReviveAI - DETAILED NEXT STEPS GUIDE (What You Must Do Now)
**Date:** 2026-06-14  
**Your exact local path:** `C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai`  
**GitHub:** https://github.com/mu-spec/revive-ai  
**Build tool:** Codemagic (your preference)  
**Phone:** CPH2083

This is the **single authoritative guide** you should follow from this point forward.  
Everything below is in the correct order. Do **not** skip steps.

---

## PHASE 1: Sync Latest Workspace Fixes to Your Local PC + Push (Do This FIRST)

The workspace now contains:
- All icon/splash fixes (professional adaptive icons + brand background)
- Updated `build.gradle.kts.fixed` with clearer signing comments
- 4 new complete guides: `PLAY_CONSOLE_IAP_SETUP.md`, `ADMOB_PRODUCTION_IDS.md`, `RELEASE_SIGNING_GUIDE.md`, `REAL_DEVICE_TEST_CHECKLIST.md`
- `PRD_VS_IMPLEMENTATION_COMPARISON_2026.md` (full honest audit)

### Step 1.1 — Copy Latest Files to Your Local Folder

On your Windows PC:
1. Open File Explorer and go to `C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai`
2. Replace these files/folders with the latest versions from this chat/workspace:
   - `android/app/build.gradle.kts.fixed`
   - `lib/services/ad_service.dart`
   - `flutter_launcher_icons.yaml`
   - `assets/images/app_icon_foreground.png`
   - All `android/app/src/main/res/mipmap-*/ic_launcher.png` (6 folders)
   - The 4 new guide files:
     - `PLAY_CONSOLE_IAP_SETUP.md`
     - `ADMOB_PRODUCTION_IDS.md`
     - `RELEASE_SIGNING_GUIDE.md`
     - `REAL_DEVICE_TEST_CHECKLIST.md`
   - `PRD_VS_IMPLEMENTATION_COMPARISON_2026.md`
   - `codemagic.yaml` (confirm it is the ultra-safe cp-only version)
   - `android/settings.gradle.kts.fixed`

3. Delete any files that still have spaces in their names (especially in drawable or mipmap folders).

### Step 1.2 — Push to GitHub (Clean CMD Block — Copy & Paste Exactly)

Open **Command Prompt** (Windows key → type `cmd` → Enter).

Copy and paste **this entire block** at once:

```cmd
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

git init

git add .

git commit -m "ReviveAI - Sync latest fixes: professional icons, signing scaffolding, full setup guides, PRD audit"

git branch -M main

git remote remove origin

git remote add origin https://github.com/mu-spec/revive-ai.git

git push -u origin main
```

**Run it now.**

- Username: `mu-spec`
- Password: GitHub password **or** Personal Access Token (recommended — repo scope only)

After success you should see:
`Branch 'main' set up to track remote branch 'main' from 'origin'.`

**Reply here with the FULL CMD output** and write exactly:
**"Phase 1 push done"**

---

## PHASE 2: Fresh Build in Codemagic + Full Device Testing on CPH2083 (Critical — Do Not Skip)

### Step 2.1 — Start a Completely Fresh Build

1. Go to https://codemagic.io and open your ReviveAI app.
2. Click **Start new build**.
3. Select branch **main**.
4. Click **Start build**.

Wait for it to finish (usually 8-15 minutes).  
Do **not** start another build until this one completes.

### Step 2.2 — Download the APK

When status is **Success**:
- Scroll to **Artifacts**
- Download `app-release.apk`

### Step 2.3 — Install & Test on Your Physical Phone (CPH2083)

**Preparation (mandatory):**
- Completely uninstall any previous ReviveAI version from the phone.
- Copy the new APK to your phone and install it.
- Grant Photos/Storage + Internet permissions when asked.

**Run the FULL checklist** from the file `REAL_DEVICE_TEST_CHECKLIST.md` (copy it to your PC and follow it exactly).

Use **this exact reporting format** when you reply:

```
APK tested on CPH2083 - [today's date]

=== Icon + Splash + Launch ===
Icon appearance: [sharp/good | blurred | wrong]
Splash screen: [shows correctly | black | nothing]
App opens from icon: [yes | no — describe exactly what happens]

=== FAL + Enhancement ===
FAL with your exact key: [success | error message]
Before/After slider: [works | broken]

=== History + Save to Gallery ===
Save confirmation dialog appears: [yes — correct text | no]
Gallery save (gal) actually saves to phone Gallery: [yes | no / permission error]
Watermark only on free results: [yes | no]

=== Premium UI differences ===
Amber "Premium Quality" badge + icon on premium items: [yes | no]

=== Batch ===
Batch button visible only for premium: [yes | no]
Batch processing works: [yes | error]

=== IAP / Premium flow ===
Purchase button behavior: [opens Play sheet | "product not found" | other]

=== Ads ===
Ads show for free users: [yes | no]
Ads hidden for premium: [yes | no]

=== Other issues found ===
[list any crashes, weird behavior, missing features, etc.]

Overall: Ready for Play Store testing? [yes / needs fixes]
```

**Reply with the above report** after you finish testing.

This step is mandatory. Previous "app not opening" and "blurred icon" issues can only be confirmed fixed by you on the real device.

---

## PHASE 3: Real In-App Purchases (IAP) — Highest Priority for Monetization

After you complete Phase 2 testing and report:

1. Read the full guide: `PLAY_CONSOLE_IAP_SETUP.md` (on your PC)
2. Create a Google Play Console account (one-time $25 fee if you don't have one).
3. Create a new app called **ReviveAI**.
4. Go to **Monetization → In-app products**.
5. Create a **Managed product** with **exact** Product ID: `premium_unlock`
6. Set title, description, and price.
7. Add your Google account as a License tester.
8. Upload at least one signed release build (you will do signing in Phase 5).
9. Create an Internal testing track and add your tester account.
10. Test the purchase flow on your CPH2083 phone using the license tester account.

**When finished, reply with:**
"Play Console IAP product created and tested on CPH2083"

See the full guide for screenshots-style steps and troubleshooting.

---

## PHASE 4: Switch to Real AdMob Production IDs (Easy — Do After IAP Setup)

1. Read `ADMOB_PRODUCTION_IDS.md`
2. Create a free account at https://apps.admob.com
3. Create an Android app called ReviveAI.
4. Create three ad units:
   - Banner
   - Interstitial
   - Rewarded
5. Copy your real IDs.
6. On your PC, open:
   `C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai\lib\services\ad_service.dart`
7. Replace the 4 test ID lines with your real IDs (clear comments are already there).
8. Save → commit → push.
9. Start a new Codemagic build.
10. Test on CPH2083 (free users should see real ads, premium users see none).

**Reply with:**
"Real AdMob IDs swapped and tested"

---

## PHASE 5: Release Signing (Keystore) — Required for Play Store & Real IAP Testing

1. Read the full guide: `RELEASE_SIGNING_GUIDE.md`
2. On your Windows PC, open Command Prompt and run (one time only):

```cmd
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai\android\app"

keytool -genkey -v -keystore reviveai-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias reviveai
```

3. Fill in the prompts (remember the passwords!).
4. The file `reviveai-release-key.jks` will be created.
5. **Backup this file safely** (Google Drive + password manager). Never lose it.
6. Go to Codemagic → your ReviveAI app → **Code signing** tab.
7. Upload the `.jks` file + enter the passwords and alias `reviveai`.
8. (Later) We will edit `build.gradle.kts.fixed` to use `signingConfigs.getByName("release")` when you are ready for signed builds.

**Reply with:**
"Keystore generated and uploaded to Codemagic"

---

## PHASE 6: Final Polish & Next Actions (After All Above Are Done)

Once you have:
- Reported successful device test (Phase 2)
- Created the IAP product (Phase 3)
- Swapped AdMob IDs (Phase 4)
- Uploaded keystore (Phase 5)

We will:
- Switch the build to use release signing
- Build a signed AAB (recommended for Play Store)
- Help you prepare Play Store listing assets (screenshots, description, privacy link, etc.)
- Do a final PRD compliance re-check with your test results

---

## Quick Reference — Exact Files You Need on Your PC

After every sync, make sure these are present:
- `REAL_DEVICE_TEST_CHECKLIST.md`
- `PLAY_CONSOLE_IAP_SETUP.md`
- `ADMOB_PRODUCTION_IDS.md`
- `RELEASE_SIGNING_GUIDE.md`
- `PRD_VS_IMPLEMENTATION_COMPARISON_2026.md`
- `codemagic.yaml` (ultra-safe version)
- `android/app/build.gradle.kts.fixed` (latest version)

---

## Communication Rules Going Forward

After every major action, reply with one of these exact phrases + any output:

- "Phase 1 push done" + full CMD output
- Full device test report in the exact format above
- "Play Console IAP product created and tested on CPH2083"
- "Real AdMob IDs swapped and tested"
- "Keystore generated and uploaded to Codemagic"

This keeps everything clear and fast.

---

**Start NOW with Phase 1.1 (copy files) + Phase 1.2 (the clean CMD push block).**

Do not start Play Console or AdMob work until you have pushed and reported the device test results.

You are very close. The remaining work is mostly external account setup + one final real-device validation.

Reply with the push output when you finish Phase 1.2. I'm ready for the next update.