# Real AdMob Production IDs — Replace Test IDs (Easy Swap)

## What This Means
The app already has full, working AdMob integration:
- Banner ads on Result screen (for free users only)
- Interstitial ads
- Rewarded ads (for "Watch Ad for 1 Extra Enhancement")
- All ads are correctly hidden when user is Premium (`adService.isPremium`)

However, it is currently using **Google's official test IDs**. These work perfectly for development and testing, but:
- They show test ads only (no real revenue).
- You cannot earn money from them.
- Google requires you to switch to your own production IDs before publishing to Play Store.

This is marked ⚠️ "Test only — Easy to swap" because the swap is literally 4 lines of code.

---

## What You Must Do (You Need an AdMob Account)

1. Go to https://apps.admob.com and sign in with a Google account.
2. If you don't have one, create an AdMob account (free, but linked to a Google account that can receive payments).
3. Create a new app:
   - App name: ReviveAI
   - Platform: Android
4. Create the three ad units you need:
   - **Banner** (320x50 or adaptive)
   - **Interstitial**
   - **Rewarded**

5. Copy the real IDs. They look like:
   - App ID: ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY
   - Banner: ca-app-pub-XXXXXXXXXXXXXXXX/1234567890
   - Interstitial: ca-app-pub-XXXXXXXXXXXXXXXX/0987654321
   - Rewarded: ca-app-pub-XXXXXXXXXXXXXXXX/1122334455

**Important**: Use the real IDs from your account. Do not use the test ones in production.

---

## How to Swap the IDs (I Have Already Prepared the File)

Open this file on your PC after you sync the workspace:

`C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai\lib\services\ad_service.dart`

Find these 4 lines near the top (I have already added clear comments):

```dart
  // TEST IDs - Replace with real ones before publishing
  static const String appId = 'ca-app-pub-7540130362404221~9152303573';
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
```

Replace them with your real IDs from AdMob.

Example after swap:

```dart
  // PRODUCTION IDs from AdMob Console
  static const String appId = 'ca-app-pub-1234567890123456~1234567890';
  static const String bannerAdUnitId = 'ca-app-pub-1234567890123456/1111111111';
  static const String interstitialAdUnitId = 'ca-app-pub-1234567890123456/2222222222';
  static const String rewardedAdUnitId = 'ca-app-pub-1234567890123456/3333333333';
```

Save the file, commit & push, then rebuild in Codemagic.

That's it — ads will now show real ads and you can earn revenue.

---

## Extra Safety (Already in Code)
- All ad loading and showing methods check `if (_isPremium)` first.
- Premium users never see ads.
- Test mode is safe during development.

## When to Do This
- Do it **before** you submit to Play Store production.
- You can keep using test IDs while testing IAP and on your CPH2083 phone.
- After swapping, test once more on device to confirm real ads appear for free users.

After you swap the IDs and test, reply:
"Real AdMob IDs swapped and tested"

This item is the easiest of the four to complete.