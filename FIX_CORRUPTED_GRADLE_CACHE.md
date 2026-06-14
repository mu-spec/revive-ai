# FIX: "Could not read workspace metadata" Error (Corrupted Gradle Cache)

## What Happened

The error:

```
Could not read workspace metadata from C:\Users\PMLS\.gradle\caches\8.14\transforms\...\metadata.bin
```

This means your **Gradle cache is corrupted**.

This usually happens when:
- Disk was completely full (0 bytes)
- Previous builds were interrupted or failed
- You deleted parts of the cache manually
- Windows had issues writing files

Gradle can no longer read its own temporary transformation files.

---

## Best Fix (Run These Commands in Order)

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

# 1. Clean Flutter project
flutter clean

# 2. Nuclear option: Delete the entire Gradle caches folder
#    (This is safe and the most effective fix)
rmdir /s /q "C:\Users\PMLS\.gradle\caches" 2>nul

# 3. (Optional but recommended) Also delete the daemon folder
rmdir /s /q "C:\Users\PMLS\.gradle\daemon" 2>nul

# 4. Get dependencies fresh
flutter pub get

# 5. Build with bypass + no daemon (cleaner)
flutter build apk --release --android-skip-build-dependency-validation --no-daemon
```

---

## One Clean Block (Copy & Paste)

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

flutter clean

rmdir /s /q "C:\Users\PMLS\.gradle\caches" 2>nul
rmdir /s /q "C:\Users\PMLS\.gradle\daemon" 2>nul

flutter pub get

flutter build apk --release --android-skip-build-dependency-validation --no-daemon
```

---

## What This Will Do

- Delete all corrupted transform/metadata files
- Force Gradle to re-download everything it needs
- Use `--no-daemon` so it doesn't use any stuck old daemon processes
- Use the bypass flag to skip version checks

**Note**: The first build after this will likely take longer (10–25 minutes) because it has to re-download a lot of files.

---

## If It Still Fails After This

Run an even more aggressive cleanup:

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

flutter clean

# Delete the entire .gradle folder for this user (very safe)
rmdir /s /q "C:\Users\PMLS\.gradle" 2>nul

flutter pub get
flutter build apk --release --android-skip-build-dependency-validation --no-daemon
```

Then restart your computer and try again.

---

## After Successful Build

The APK will be at:

`build\app\outputs\flutter-apk\app-release.apk`

---

## Quick Reminder

You can ignore these warnings for now:
- "Building with plugins requires symlink support"
- Old Kotlin / AGP version warnings

The priority is getting a working build.

---

Run the block above and paste the output (especially the end of the build).