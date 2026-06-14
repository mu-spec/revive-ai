# Next Steps After Successful App Icon Generation (2026-06-10)

## Great Progress!

You now have:
- `flutter pub get` succeeded
- `flutter pub run flutter_launcher_icons` succeeded with `✓ Successfully generated launcher icons`

The app icon is now properly generated.

---

## 1. Re-Apply Your Manual Splash Screen (Important)

`flutter create .` or other operations may have reset parts of the `android/` folder.

Re-do the manual splash steps to make sure they are still in place:

### Run these:

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

# Create drawable folder
mkdir -p android\app\src\main\res\drawable

# Copy splash images
copy assets\images\splash_background.png android\app\src\main\res\drawable\
copy assets\images\splash_logo.png android\app\src\main\res\drawable\
```

### Then manually ensure these two files exist:

**A.** `android\app\src\main\res\drawable\splash.xml`

Paste this content:

```xml
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@drawable/splash_background" />
    <item>
        <bitmap
            android:gravity="center"
            android:src="@drawable/splash_logo" />
    </item>
</layer-list>
```

**B.** Edit `android\app\src\main\res\values\styles.xml`

Make sure the `LaunchTheme` looks like this:

```xml
<style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
    <item name="android:windowBackground">@drawable/splash</item>
</style>
```

---

## 2. Final Clean + Build Release APK

After re-applying the splash, run:

```bash
flutter clean
flutter pub get

flutter build apk --release
flutter build appbundle --release
```

The release APK will be here:
`build\app\outputs\flutter-apk\app-release.apk`

---

## 3. Important Windows Warning You Saw

You saw this message:

> Building with plugins requires symlink support.
> Please enable Developer Mode in your system settings.
> Run: start ms-settings:developers

### Recommended Action (Do This Once)

1. Press `Win + R`, type this and press Enter:
   ```
   start ms-settings:developers
   ```

2. Turn **ON** "Developer mode".

3. Restart your PC (or at least restart the terminal).

This fixes symlink issues that can cause problems with plugins (especially `in_app_purchase`, `google_mobile_ads`, etc.) during builds.

---

## 4. Install & Test on Your Phone

1. Copy the new `app-release.apk` to your CPH2083 phone.
2. **Uninstall** any old version of ReviveAI.
3. Install the new APK.
4. Launch the app.

### Test Checklist:
- [ ] App icon on home screen looks professional (your custom icon)
- [ ] Custom splash screen appears when launching (background + centered logo)
- [ ] Splash disappears cleanly
- [ ] App opens to Enhance screen with modern UI

Then do a quick functional test:
- Enter your FAL key in Settings
- Try one enhancement
- Check History → Save button (with confirmation)
- Check Result screen Save with loading

---

## Full Recommended Command Block

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

# Re-apply manual splash
mkdir -p android\app\src\main\res\drawable
copy assets\images\splash_background.png android\app\src\main\res\drawable\
copy assets\images\splash_logo.png android\app\src\main\res\drawable\

# (Manually ensure splash.xml and styles.xml are correct — see above)

flutter clean
flutter pub get

flutter build apk --release
flutter build appbundle --release
```

---

## Next After Testing on Phone

Reply with:
- "Icon + Splash working on phone"
- Any issues you see (e.g. "Splash still default", "Icon not updated", etc.)

Then we can:
- Do full app testing
- Decide about Developer Mode + real AdMob
- Prepare the final AAB for your senior

You're very close now! Run the commands and let me know the results.