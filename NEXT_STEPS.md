# ReviveAI - Current Status & Next Steps (as of 2026-06-07)

**IMPORTANT**: All development must happen **on your local Windows machine** (your 8GB RAM laptop). The Arena workspace environment has broken Flutter setup and cannot reliably run/build the app. Use a lightweight emulator or (strongly recommended) a real Android device.

## What Has Been Completed (per PRD + previous priorities)

- Full Android-only Flutter project (iOS/web folders removed).
- EASY START Replicate integration (all 6 modes: One-Tap, Old Photo Restore, Face Enhance, Colorize, Unblur/Upscale, Background Cleanup).
- Before/After slider, local history (with thumbnails), watermark on free results ("ReviveAI Free" in red).
- Batch processing for Premium users (sequential, with progress).
- Real In-App Purchase foundation:
  - PurchaseService fully implemented with `in_app_purchase` plugin.
  - Product ID: `premium_unlock` (non-consumable).
  - Buy + Restore flows wired.
  - Settings has real "Unlock Premium (Buy)" button + "Restore Purchases".
  - Premium status saved locally + streamed.
  - Batch + no watermark gated on real premium.
- AdMob with **test IDs** (safe for dev). Real IDs noted in code/comments.
- Legal docs (Privacy Policy + Terms) bundled in-app + HTML versions ready for external hosting.
- Daily limits (5 free), history, Replicate API key management (no login system — per PRD).
- History tab fully implemented (list, delete, open results).

## Critical Blocker Right Now: Real IAP Requires Google Play Console

You said you currently have **no Play Store account**.

### What you MUST do to complete real Premium (highest priority item)

**Step 1: Create a Google Play Console developer account (required for any IAP or publishing)**

1. Go to: https://play.google.com/console/signup
2. Sign in with a Google account.
3. Pay the **one-time $25 USD developer registration fee** (non-refundable).
4. Accept the terms and complete the account setup (provide country, etc.).

This is the **only way** to create in-app products and test real purchases on Android.

**Step 2: Once you have the account, set up the app and the Premium product**

1. In Play Console, create a new app (or use an existing one).
   - App name: ReviveAI (or whatever you choose).
   - Default language: English.
   - Package name: Use a unique one (check your local `android/app/build.gradle.kts` → `applicationId`).
     Recommended: `com.yourname.reviveai` or `com.reviveai.app` (change it if it's still the default com.example...).

2. Go to **Monetize > In-app products > Create product**.

3. Fill exactly:
   - **Product ID**: `premium_unlock` (must match the code exactly)
   - **Product type**: Non-consumable (one-time purchase)
   - **Title**: Premium Unlock
   - **Description**: Unlock unlimited photo enhancements, remove ads and watermarks, enable batch processing, and get priority results.
   - **Price**: Choose your price (e.g. $4.99 USD or local equivalent). You can change later.
   - Save and **Activate** the product.

4. **Set up testing (very important — so you don't pay real money)**:
   - Go to **Setup > License testing**.
   - Add the email addresses of Google accounts you will use for testing (e.g. your personal Gmail).
   - These test accounts can make "purchases" for free during testing.

5. Upload a signed app bundle for testing:
   - On your local machine, first run:
     ```bash
     flutter clean
     flutter pub get
     ```
   - Then build a release AAB:
     ```bash
     flutter build appbundle --release
     ```
   - The file will be at `build/app/outputs/bundle/release/app-release.aab`
   - In Play Console: **Testing > Internal testing > Create new release** > upload the AAB.
   - Add testers (your test emails).
   - Publish the internal test track (it can take a few hours to be available).

6. On a **real Android phone** (emulator often fails for billing):
   - Sign in with one of the test accounts you added.
   - Open the Play Store app and opt-in to the internal test (link provided in Play Console).
   - Install the test version of ReviveAI.
   - Open the app → go to Settings → tap "Unlock Premium (Buy)".
   - The Google Play billing screen should appear. For test accounts it will say "This is a test order" and you can complete without real payment.
   - After purchase, premium should activate (no ads, batch enabled, no watermark).

**Step 3: Verify in the app**

- After successful test purchase, premium status should persist across app restarts.
- Free users: see watermark + ads + daily limit + no batch button.
- Premium: no watermark, no ads, batch button visible, unlimited daily.

If the "Product not found" message appears in console/logs, double-check the Product ID and that the product is **Active** in Play Console.

## Other Important Local Commands (run on your machine)

```bash
# After any code change
flutter clean
flutter pub get

# Run on device (real device preferred for IAP and ads)
flutter run

# For release AAB (needed for Play Console)
flutter build appbundle --release
```

## Current Code State & Known Limitations

- Ad units: Currently using **Google test IDs** (safe). Switch to your real ones (listed in ad_service.dart comments) only before final release.
- Premium differentiation: Currently UI + limits + watermark + batch. Real "faster processing" is still simulated (as Replicate calls are the same). You can add hints later ("Premium processes 2x faster").
- No external hosting of legal HTML yet (privacy.html / terms.html in legal/ folder are ready — you can host on GitHub Pages, Netlify, or your site later for Play Store requirements).
- App icon/splash: User will provide later.
- Package name: Change from default to unique before publishing.
- Keystore signing: Required for Play Store (generate upload key).

## Remaining PRD Items (after IAP is working)

Prioritized (do these only after confirming real IAP works on device):
1. Play Store release preparation (package name, signing, AAB, store listing, screenshots).
2. Better Premium value (e.g. speed hints in UI, multiple model options).
3. Add Cartoon/Anime enhancement mode (new Replicate model).
4. Dedicated Portrait Improve mode.
5. Analytics (optional).
6. External host legal pages + add links in app.

## What to Do Right Now (your question)

1. Decide if you want to proceed with real IAP:
   - Yes → Create the $25 Play Console account and follow Step 2 above.
   - No / later → We can leave the purchase code as-is (UI ready) and move to other features (e.g. new enhancement modes) using the current "purchase will work later" state.

2. **Reply here with**:
   - "I created the Play Console account — next steps for product creation" or
   - "I don't have budget for the $25 fee yet, let's work on other features first (e.g. Cartoon mode)"

3. Download/sync the latest code from this workspace to your local machine (the history files, service fixes, and cleanup were just added).

4. On your local machine run `flutter pub get` then test the current UI (buy button will do nothing or show "product not found" until you complete Play Console setup).

## Test Ad IDs (current in code — do not change yet)
- Banner: ca-app-pub-3940256099942544/6300978111
- Interstitial: ca-app-pub-3940256099942544/1033173712
- Rewarded: ca-app-pub-3940256099942544/5224354917

Real IDs (for later):
App: ca-app-pub-7540130362404221~9152303573
etc. (see ad_service.dart)

## Questions?

Tell me exactly where you are (e.g. "I just paid for Play Console" or "Skip IAP for now") and I'll give the precise next code changes + exact commands.

We will complete items one by one and ask for confirmation before moving on.
