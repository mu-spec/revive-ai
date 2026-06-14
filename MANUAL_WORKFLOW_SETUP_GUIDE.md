# How to Manually Create "Build Release APK" Workflow in GitHub UI

You are on the "Get started with GitHub Actions" screen with "Found 0 workflows".

Follow these exact steps to create **your own workflow** manually.

## Step-by-Step Instructions

1. On the current GitHub Actions page, click the blue link:
   **"Skip this and set up a workflow yourself"**

2. GitHub opens the editor with some default YAML content and a filename like `blank.yml`.

3. **Delete everything** in the big editor box (select all + delete).

4. **Paste the full clean YAML** (copy the entire block below):

```yaml
name: Build Release APK

on:
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.29.2'
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Clean project
        run: |
          flutter clean
          flutter pub get

      - name: Force AGP 8.7.0 + Kotlin 2.0.21 + NDK 27 + compileSdk 36 (BULLETPROOF - full file overwrites)
        run: |
          # Force gradle.properties
          echo "androidGradlePluginVersion=8.7.0" >> android/gradle.properties
          echo "android.useAndroidX=true" >> android/gradle.properties
          echo "android.enableJetifier=true" >> android/gradle.properties

          echo "=== BEFORE overwrites ==="
          echo "settings.gradle.kts Kotlin line:"
          grep 'org.jetbrains.kotlin' android/settings.gradle.kts || true
          echo "app/build.gradle.kts:"
          grep -n 'compileSdk\|ndkVersion' android/app/build.gradle.kts || true

          # 1. Overwrite settings.gradle.kts with correct Kotlin 2.0.21 + AGP 8.7.0
          cat > android/settings.gradle.kts << 'SETTINGS_EOF'
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
    id("com.android.application") version "8.7.0" apply false
    id("org.jetbrains.kotlin.android") version "2.0.21" apply false
}

include(":app")
SETTINGS_EOF

          # 2. Overwrite app/build.gradle.kts with NDK 27.0.12077973 (highest required by all plugins) + compileSdk 36
          cat > android/app/build.gradle.kts << 'APP_EOF'
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.revive_ai"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    defaultConfig {
        applicationId = "com.example.revive_ai"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
APP_EOF

          echo "=== FINAL settings.gradle.kts (Kotlin line) ==="
          grep 'org.jetbrains.kotlin' android/settings.gradle.kts || true
          echo "=== FINAL app/build.gradle.kts ==="
          grep -n 'compileSdk\|ndkVersion' android/app/build.gradle.kts || true

      - name: Build Release APK
        run: flutter build apk --release --android-skip-build-dependency-validation

      - name: Upload APK artifact
        uses: actions/upload-artifact@v4
        with:
          name: revive-ai-release-apk
          path: build/app/outputs/flutter-apk/app-release.apk
          retention-days: 7
```

5. At the top of the editor, change the filename box to **exactly** this:
   ```
   .github/workflows/build-release-apk.yml
   ```

6. Scroll down and commit:
   - Commit message: `Create Build Release APK workflow (bulletproof - Kotlin 2.0.21 + NDK 27)`
   - Click the green **Commit new file** button.

7. After commit:
   - Go back to the **Actions** tab.
   - Hard refresh the page (`Ctrl + Shift + R`) 2-3 times.
   - "Build Release APK" should now appear on the left.
   - Click it → click green **Run workflow** button → select `main` → Run.

This is you manually creating "your own workflow" in the UI.

All fixes (full overwrites for the errors you had) are included.
