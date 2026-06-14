# FIX: settings.gradle.kts Error (Kotlin DSL)

## Problem

Your project uses **Kotlin DSL** for Gradle files:
- `settings.gradle.kts` (not `settings.gradle`)

You pasted **Groovy** syntax into a `.kts` file. This is why you're getting tons of "Expecting an element", "Unresolved reference: def", etc.

---

## Correct Fix (Replace the Whole File)

### Step 1: Open and Replace Content

Open this file:

`C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai\android\settings.gradle.kts`

**Delete everything** inside it and paste the following **correct Kotlin DSL** code:

```kotlin
pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.2.1" apply false
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
}

include(":app")
```

Save the file.

---

### Step 2: Build the Release APK Only

Run these commands **exactly** in order:

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

flutter clean
flutter pub get
flutter build apk --release
```

---

### Alternative (One Block - Copy & Paste)

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

flutter clean
flutter pub get
flutter build apk --release
```

---

## After Build Succeeds

The release APK will be here:

```
build\app\outputs\flutter-apk\app-release.apk
```

Copy this file to your phone → uninstall old version → install → test.

---

## Extra: Re-apply Manual Splash (If Needed)

Before building, make sure these are in place:

1. Images copied:
   ```bash
   mkdir -p android\app\src\main\res\drawable
   copy assets\images\splash_background.png android\app\src\main\res\drawable\
   copy assets\images\splash_logo.png android\app\src\main\res\drawable\
   ```

2. `splash.xml` exists at:
   `android\app\src\main\res\drawable\splash.xml`

   (With the layer-list code you had earlier)

3. `styles.xml` has:
   ```xml
   <item name="android:windowBackground">@drawable/splash</item>
   ```

---

## Quick Rebuild After Any Change

```bash
flutter clean
flutter pub get
flutter build apk --release
```

---

Run the commands above and tell me if the build succeeds this time.