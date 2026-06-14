# Commands to Build ONLY the Release APK (Simplest Way)

Run these commands in order on your Windows PC.

## Recommended Commands (Copy-Paste Block)

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

flutter clean
flutter pub get
flutter build apk --release
```

---

## If You Get the Kotlin Error Again

Use this version with the bypass flag:

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

flutter clean
flutter pub get
flutter build apk --release --android-skip-build-dependency-validation
```

---

## After the Build Finishes

The release APK will be located here:

```
build\app\outputs\flutter-apk\app-release.apk
```

Copy this file to your phone and install it.

---

## Quick Rebuild Sequence (Whenever You Make Changes)

```bash
flutter clean
flutter pub get
flutter build apk --release
```

---

## After Installing on Phone

- Uninstall old version first
- Install the new APK
- Test icon + splash + basic features (especially History Save)

Let me know if the build succeeds or paste any error.
