# Google AdMob Integration Guide for ReviveAI (Android Only)

## Your AdMob IDs (Already Integrated in Code)

- **App ID**: `ca-app-pub-7540130362404221~9152303573`
- **Banner Ad Unit ID**: `ca-app-pub-7540130362404221/6541462424`
- **Interstitial Ad Unit ID**: `ca-app-pub-7540130362404221/4375149844`
- **Rewarded Ad Unit ID**: `ca-app-pub-7540130362404221/3732455938`

## 1. Add Dependency (Already Done)

`google_mobile_ads: ^5.1.0` has been added to pubspec.yaml.

Run this on your machine:
```bash
flutter pub get
```

## 2. Android Configuration (Required for Play Store)

### Step 1: Update AndroidManifest.xml

Open: `android/app/src/main/AndroidManifest.xml`

Add the following **inside** the `<application>` tag:

```xml
<!-- AdMob App ID -->
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-7540130362404221~9152303573"/>
```

Also ensure you have internet permission at the top:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### Step 2: Update build.gradle (if needed)

In `android/app/build.gradle.kts` (or .gradle), make sure `minSdkVersion` is at least 21.

## 3. Test Mode (Important!)

While developing, use **test ad units** to avoid policy violations.

Replace in `lib/services/ad_service.dart` temporarily for testing:

```dart
static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Test Banner
static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712'; // Test Interstitial
static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917'; // Test Rewarded
```

**Remember to switch back to your real IDs before publishing.**

## 4. How Ads Are Integrated (As per Document)

- **Free Tier**: Shows ads (Banner on result screen + Interstitial after enhancement) + watermark on results
- **Premium**: No ads (fully respected) + no watermark + batch processing

The implementation follows the monetization strategy from the original document:
- Free users see ads + watermark
- Premium users see no ads + clean results + batch

## 5. Next Steps

1. Run `flutter pub get`
2. Apply the Android changes above on your local machine (you already did the manifest)
3. Test on a real Android device (emulators often don't show real ads well and are heavy on low-RAM machines)
4. For production, submit your app to AdMob for review if needed
5. Set up app signing for Play Store release

If you need help with any step (especially Play Store publishing or signing), provide the error and I'll assist.

**Note**: This project is configured for Android only (iOS folder removed). If you ever want to add iOS support later, you can re-add it with `flutter create . --platforms ios`.
