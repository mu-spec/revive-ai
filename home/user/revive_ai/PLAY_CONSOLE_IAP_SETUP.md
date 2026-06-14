# Real In-App Purchase (IAP) Setup — Google Play Console (Required for Real Premium)

## What This Means
The code for buying Premium (`premium_unlock`) is **100% real and complete** in the app:
- `lib/services/purchase_service.dart` has `buyPremium()`, `restorePurchases()`, product query, and status saving.
- All features correctly gate on `purchaseService.isPremium` (no daily limit, no watermark, no ads, batch enabled, quality boost).
- The product ID used everywhere is `premium_unlock`.

However, **Google Play Console is required** to make purchases actually work on real devices. Without it:
- `buyPremium()` will always return "Product not found".
- Users cannot pay and unlock Premium.
- This is the #1 blocker for real monetization.

This is **not a code problem** — it is the normal last step for any Android app with IAP.

---

## Step-by-Step: Create the Real Product (You Must Do This)

### 1. Create / Access Google Play Console
1. Go to https://play.google.com/console
2. Sign in with a Google account (you need a one-time $25 developer fee if you don't have a Console account yet).
3. If you haven't, create a new app:
   - App name: `ReviveAI`
   - Default language: English
   - App or game: App
   - Free or paid: Free (you will add in-app products)
   - Category: Photography or Tools

### 2. Set Up Your App for In-App Products
1. In the left menu go to **Monetization** → **In-app products** (or "Subscriptions & in-app products").
2. Click **Create product** (or "In-app product").
3. Fill exactly:
   - **Product ID**: `premium_unlock`   ← MUST match the code
   - **Product type**: Managed product (one-time purchase, non-consumable)
   - **Title**: `ReviveAI Premium`
   - **Description**: `Unlock unlimited enhancements, remove all ads and watermarks, enable batch processing, and get higher quality results.`
   - **Price**: Choose a price (e.g. $4.99 or whatever you want). Make it the same in all countries or use auto-convert.
   - **Status**: Set to **Active** when ready.
4. Save the product.

### 3. Add License Testers (Important for Testing Without Paying)
1. In Play Console go to **Setup** → **License testing**.
2. Add your Google account email(s) that you will use on the test phone.
3. Add any friends/family you want to test with.
4. Save.

### 4. Upload a Signed Release AAB or APK (Required Before IAP Can Be Tested)
You cannot test real purchases until you upload at least one release build.

- Use Codemagic to build a signed AAB (recommended) or APK.
- See the "Release Signing" section below + the guide in `RELEASE_BUILD_INSTRUCTIONS.md`.

After upload:
- Go to **Testing** → **Internal testing** (easiest for now).
- Create a track, add your license testers.
- Publish the internal test.

### 5. Test the Purchase Flow
On your CPH2083 phone (using a license tester account):
1. Install the release build from internal testing.
2. Go to Settings → tap "Unlock Premium".
3. You should see the Google Play purchase sheet with the real price.
4. Complete the purchase (you will not be charged if using license tester).
5. After success, the app should immediately show Premium benefits (no ads, batch button appears, etc.).

If it still says "product not found", wait 1-2 hours after creating the product and re-upload a new build.

### 6. Switch to Production Later
Once testing is good:
- Move the product to "Published" status.
- Create a Production track in Play Console.
- Submit the app for review (you will need screenshots, description, privacy policy link, etc.).

---

## What the Code Already Does (No Changes Needed)
- Queries the exact product ID `premium_unlock`.
- Handles purchase success → saves `is_premium_unlocked = true` in SharedPreferences.
- Restores purchases on app start.
- All UI and logic gates on the real `isPremium` value.
- Shows clear error if product is not found (helpful during setup).

You only need to do the Play Console steps above.

---

## Common Problems & Fixes
- "Product not found" → Product not yet active, or wrong Product ID, or no release build uploaded yet.
- Purchase sheet doesn't appear → App not signed, or not uploaded to a testing track, or tester not added.
- Purchase succeeds but app doesn't unlock → Check logs for "premium_unlock" matching exactly.

After you complete the Play Console steps, reply here with:
"Play Console IAP product created and tested on CPH2083"

Then we can mark this item as fully live.

---

**You cannot skip this step** if you want real paying Premium users. This is the standard process for every Android app with in-app purchases.