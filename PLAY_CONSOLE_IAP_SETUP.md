# Google Play Console - premium_unlock IAP Setup Guide

**Important for the Senior Developer who owns the Play Console account**

This document gives exact instructions to set up real In-App Purchase for ReviveAI Premium.

## Product Details (Must be exact)

- **Product ID**: `premium_unlock` (this is hardcoded in the app code — do not change)
- **Product Type**: Non-consumable (one-time purchase)
- **Title**: ReviveAI Premium (or "Premium Unlock")
- **Description** (copy exactly or improve slightly):
  "Unlock unlimited photo enhancements with AI. Remove daily limits, watermarks, and ads. Enable batch processing of multiple photos at once. One-time purchase."
- **Price**: Choose any (recommended starting price: $4.99 USD or equivalent in local currency). You can change price later.
- **Status**: Must be set to **Active**

## Step-by-Step Instructions (for the Play Console owner)

### Step 1: Open or Create the App in Play Console
1. Go to https://play.google.com/console
2. Select the existing ReviveAI app (or create a new one if this is the first release).
3. Make sure the **Package name** matches what is in the app:
   - Check in the project: `android/app/build.gradle.kts`
   - Look for `applicationId "com.yourname.reviveai"` (or similar)
   - If it is still the default (com.example...), change it to something unique before building the release AAB.

### Step 2: Create the In-App Product
1. In the left menu, go to **Monetize** → **In-app products**
2. Click **Create product**
3. Fill in exactly:
   - Product ID: `premium_unlock`
   - Type: **Non-consumable**
   - Title: `ReviveAI Premium`
   - Description: Paste the description from above
   - Default price: Set your price (e.g. 4.99)
4. Click **Save**
5. After saving, click **Activate** (very important — the product must be Active)

### Step 3: Set Up License Testing (Critical for Testing Without Real Money)
1. Go to **Setup** → **License testing** (in the left menu)
2. Under "License testers", add the Google account email(s) that will be used for testing.
   - Example: your personal Gmail, the developer's email, any tester emails.
3. Save changes.
4. These test accounts will be able to "buy" the product for free during testing.

### Step 4: Upload a Release Build for Testing (Internal Testing Track)
The app must be uploaded as a signed AAB before testers can download it.

**For the developer (you may need to ask them to do this part):**

On the developer's local machine, run these commands in the `revive_ai` folder:

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

The file will be created at:
`build/app/outputs/bundle/release/app-release.aab`

Then:
1. In Play Console → **Testing** → **Internal testing**
2. Click **Create new release**
3. Upload the `app-release.aab` file
4. Add release notes (example: "Initial test build with real Premium IAP")
5. Add the tester emails you added in License testing
6. Click **Save** → **Review release** → **Start rollout to Internal testing**

It can take a few hours (sometimes up to 1 day) for the test version to become available.

### Step 5: Tester Instructions (share with testers)
Testers must:
1. Open the Google Play Store app on their Android phone.
2. Search for the app or use the internal testing link provided by Play Console.
3. Opt-in to the internal test.
4. Install the app.
5. Sign in to the app using the **same Google account** that was added to License testing.
6. Go to Settings → tap "Unlock Premium (Buy)"
7. The purchase screen should appear with a message like "This is a test order".
8. Complete the purchase (free for test accounts).
9. Premium should activate immediately (no ads, batch enabled, no watermark).

### After Setup
- Once the product is Active and at least one successful test purchase is done, real users can buy it when the app goes live.
- You can later change the price or add a subscription version if wanted.
- The app code is already 100% ready — no code changes needed on the developer side for the purchase flow.

## What the Developer Needs From You (Senior)
Please reply with:
- The exact package name you want to use (or confirm the current one)
- Whether you will create the product yourself or add the developer as a user with "Release manager" or "Admin" permissions
- The list of tester emails to add
- Confirmation once the product is Active and the internal test build is rolled out

## Current App Code Status
- Product ID in code: `premium_unlock`
- PurchaseService fully implemented
- Gating for batch, watermark, ads, and daily limits already wired to real premium status
- All ready for real IAP

---

**Note for the developer**: Work only on your local Windows machine. After any code change run:
```bash
flutter clean
flutter pub get
```

When the senior gives you the internal testing link + tester account, test on a **real Android phone** (not emulator).

This setup follows the original PRD requirements.
