# Quick Fix: Duplicate "http" in pubspec.yaml

## Error You Got
```
Error on line 32, column 3: Duplicate mapping key.
   http: ^1.6.0
```

This is a **YAML syntax error**. The package `http: ^1.6.0` was accidentally listed **twice** in your `pubspec.yaml` file.

---

## Fix (Already Done in Workspace)

I have removed the duplicate line.

### On Your Windows PC — Do This Now:

1. **Copy the latest `pubspec.yaml`** from this workspace to your local folder:
   `C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai\pubspec.yaml`

   (Or manually open the file and make sure `http` appears only **once**.)

2. Run these commands in order:

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

flutter clean
flutter pub get
```

3. Now retry the icon generator:

```bash
flutter pub run flutter_launcher_icons
```

You should now see success messages like:
```
✓ Successfully generated launcher icons for Android
```

---

## After the Icon Command Succeeds

Continue with the build:

```bash
flutter clean
flutter pub get

flutter build apk --release
flutter build appbundle --release
```

---

## Full Clean Sequence (Recommended)

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

flutter clean
flutter pub get

flutter pub run flutter_launcher_icons

flutter clean
flutter pub get

flutter build apk --release
```

---

**Note**: The duplicate `http` line was introduced earlier (probably during one of the many package additions). It's now fixed.

After you run the above and the icon generation succeeds, install the new release APK on your phone and test the splash + icon.

Let me know the result!