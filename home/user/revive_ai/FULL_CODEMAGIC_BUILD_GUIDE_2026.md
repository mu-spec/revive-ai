# FULL STEP-BY-STEP: Push Changes + Build Release APK in Codemagic (ReviveAI)

**Date:** 2026-06-14  
**Your local path (use exactly):** `C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai`  
**GitHub repo (target):** https://github.com/mu-spec/revive-ai  
**Codemagic:** https://codemagic.io  
**Phone for testing:** CPH2083 (uninstall old APK first every time)

---

## CRITICAL CLARIFICATION (Your Question #1)

You asked:  
> "in this sentence you say to push this changes. so wherer you will push this"

**Answer:**  
**I (the AI) do NOT push anything.**  
All pushes happen **by YOU** on **your Windows PC** using Command Prompt (CMD).

- This workspace (/home/user/revive_ai) is the **clean master copy** of every fixed file (codemagic.yaml ultra-safe version, .fixed gradle files, splash fixes, icon fixes, FAL key, History premium dialog, watermark logic, etc.).
- You must copy/apply these clean files to your local folder on the C: drive, then run git commands **on your PC** to push to GitHub.
- The AI gives you the exact copy-paste commands and the full guide. You execute them locally.

**Why this way?**  
The sandbox here has no access to your GitHub credentials or your local C: drive. This is the only reliable method that has worked in previous successful setups.

---

## STEP 0: Make Sure Your Local Folder Has the Clean Files (Do This First)

The workspace here already has the **perfect clean version** (no space in filenames, correct splash + launcher icons in all mipmaps, safe codemagic.yaml with only `cp` commands, correct FAL key, updated History/Premium/Watermark/Batch/AdMob code).

**On your Windows PC:**
1. Open File Explorer.
2. Go to `C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai`
3. **Compare or overwrite** the following key files/folders with the clean versions from this workspace (you can see them here in the chat/workspace):
   - `codemagic.yaml` (the ultra-safe one with only `cp` lines)
   - `android/settings.gradle.kts` ← replace with content from `android/settings.gradle.kts.fixed`
   - `android/app/build.gradle.kts` ← replace with content from `android/app/build.gradle.kts.fixed`
   - Entire `android/app/src/main/res/drawable/` (splash.xml + splash_background.png + splash_logo.png — no spaces!)
   - All `android/app/src/main/res/mipmap-*/ic_launcher.png` (6 folders — use the clean 1337592-byte versions)
   - `android/app/src/main/AndroidManifest.xml`
   - `android/app/src/main/res/values/styles.xml` and `values-night/styles.xml`
   - `android/app/src/main/kotlin/com/example/revive_ai/MainActivity.kt` (if exists)
   - `lib/main.dart`
   - `lib/services/ai_provider_service.dart` (FAL with your exact key)
   - `lib/screens/history_screen.dart` (premium badge + icon + confirmation dialog)
   - `lib/services/purchase_service.dart`
   - `lib/services/ad_service.dart`
   - `android/gradle.properties` (must have the androidGradle lines)

If your local folder is out of date, **copy the entire contents** from the workspace preview into your local folder (replace everything except your personal photos if any).

**After copying:** Delete any files that have spaces in name (e.g. anything with "copy" or " ").

---

## STEP 1: Create the GitHub Repository (MUST DO BEFORE PUSH)

1. Go to https://github.com and log in with **mu-spec**.
2. Click the green **+** → **New repository**.
3. Repository name: `revive-ai` (exactly, lowercase).
4. Description: `ReviveAI - AI Photo Enhancer (Android only)`.
5. **Public** or Private — your choice.
6. **UNCHECK** "Add a README", ".gitignore", and license.
7. Click **Create repository**.

Repo URL must be: https://github.com/mu-spec/revive-ai.git

---

## STEP 2: Push from Your Local PC (Clean CMD Block - Copy & Paste Exactly)

**Open Command Prompt** (Windows key → type `cmd` → Enter).

Copy and paste **this entire block** at once (zero # comments inside so CMD is happy):

```cmd
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

git init

git add .

git commit -m "ReviveAI clean release - FAL key + History premium + splash + icons + safe codemagic.yaml"

git branch -M main

git remote remove origin

git remote add origin https://github.com/mu-spec/revive-ai.git

git push -u origin main
```

**Run it now.**

- When it asks for username: type `mu-spec`
- When it asks for password: use your GitHub password **OR** (strongly recommended) a Personal Access Token:
  - Create token: GitHub → Profile → Settings → Developer settings → Personal access tokens → Tokens (classic) → Generate new token (classic) → check only **repo** scope → Generate → copy the token and paste it here as password.

After success you should see:
```
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

**If it says "Repository not found"**:
- Confirm you created https://github.com/mu-spec/revive-ai exactly.
- Make sure you are logged into mu-spec in your browser.

**Reply here with the full CMD output** and say **"Git push done"** (or paste any error).

---

## STEP 3: Update Email in codemagic.yaml (After Successful Push)

On your PC:
1. Open `C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai\codemagic.yaml` in Notepad.
2. Change the line:
   ```
   - your-email@example.com
   ```
   to your real email address.
3. Save the file.
4. Run these commands in CMD:

```cmd
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

git add codemagic.yaml

git commit -m "Update email for Codemagic notifications"

git push
```

---

## STEP 4: Build in Codemagic (Fresh Build Every Time)

1. Go to https://codemagic.io and **Sign in with GitHub** (authorize it).
2. Click **Add application**.
3. Select account **mu-spec**.
4. Select repository **revive-ai**.
5. Click **Next** → it should detect `codemagic.yaml`.
6. Choose **Flutter** project type.
7. Click **Finish: Add application**.

**Start the build:**
1. On the dashboard, find the workflow **Build Release APK**.
2. Click **Start new build**.
3. Select branch **main**.
4. Click **Start build**.

Wait 8–15 minutes.  
Do **not** cancel or start another build until it finishes.

---

## STEP 5: Download & Install the APK

1. When status is **Success** (green), scroll to **Artifacts**.
2. Click **app-release.apk** to download.
3. Copy the APK to your phone (CPH2083).
4. **Uninstall any previous ReviveAI version completely** (long-press icon → Uninstall).
5. Install the new APK.
6. Open the app.

---

## STEP 6: Full Phone Test Checklist on CPH2083 (Report Back Exactly)

After install and open:

- [ ] App icon appears sharp and correct (not blurred)
- [ ] Custom splash screen shows (your splash_logo on background)
- [ ] App opens without crash or black screen
- [ ] Bottom nav: Enhance / History / Settings
- [ ] In Settings: FAL is default provider and your key is visible or pre-filled: `f3328d24-2198-47d9-ba11-e6517e693a18:cafaec7896d7f116a4cd12d6874552ae`
- [ ] Enhance one photo → works with FAL (no error)
- [ ] Go to History → see your result
- [ ] In History: Free result has normal download icon + "Save to Gallery"
- [ ] Premium result (if you bought or simulated) shows amber crown badge + "Premium Quality" label + amber workspace_premium icon for Save button
- [ ] Tap Save in History → confirmation dialog appears with correct text
- [ ] Save succeeds → "Saved to Gallery successfully!" green snackbar
- [ ] Result opens in Result screen with before/after slider
- [ ] Watermark "ReviveAI Free" only on free (non-premium) results
- [ ] Batch processing works for premium users
- [ ] Legal links open external Netlify pages (privacy + terms)
- [ ] No login screen anywhere
- [ ] AdMob initializes (may show test ads)

**Reply with this exact format:**
```
APK downloaded and tested on CPH2083

Icon: [good / blurred]
Splash: [shows / black]
Opens: [yes / no]
FAL key used: [yes / error message]
History save dialog: [shows correctly / problem]
Premium badge/icon difference: [yes / no]
Watermark only on free: [yes / no]
Batch: [works / problem]
Other issues: [list any]
```

---

## What Is Already Fixed in This Clean Version (All Half-Done Items)

From your table:
- ✅ FAL AI Integration (default provider, your exact key hardcoded in ai_provider_service.dart with premium strength/steps)
- ✅ History Screen + Save to Gallery (gal package + loading + confirmation dialog + premium-specific amber icon/text/"Premium Quality" badge)
- ✅ Premium / In-app Purchase (structure in purchase_service.dart + checks everywhere)
- ✅ Watermark (only on free results — logic in enhance/result screens)
- ✅ Batch Processing (premium-only, robust per-item handling)
- ✅ Before/After Slider (fully integrated)
- ✅ AdMob (initialized safely, premium removal logic in ad_service.dart)

**Every prior feature preserved exactly** (Android-only, no login, manual splash, Netlify legal links, etc.).

---

## If You Get Errors

- Paste the **last 15-20 lines** of the Codemagic build log.
- Or the exact phone behavior after install.
- Common past errors fixed: heredoc parse error, space in resource names, wrong AGP/Kotlin/NDK, broken splash/launcher, app not opening.

---

## Next After Successful Test

We will:
- Verify IAP in Play Console (real product ID `premium_unlock`)
- Add proper signing for Play Store AAB if needed
- Final polish on any remaining half-done items

**Start now with Step 1 (create GitHub repo) + Step 2 (clean CMD block).**

Reply with the CMD output after the push block! We are very close. 🚀

All files in this workspace are ready and clean for you to use locally.