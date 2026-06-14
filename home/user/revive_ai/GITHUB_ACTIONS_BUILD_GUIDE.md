# IMPORTANT: How to Make "Build Release APK" Appear in Actions Tab

**Problem you are seeing right now**: You do not see "Build Release APK" on the left side of the Actions tab. You probably still see the "Get started with GitHub Actions" screen or only old failed runs.

**Root cause (happened multiple times)**: The workflow file was saved in the **wrong nested folder** on GitHub (for example `.github/workflows/github/workflows/build-release-apk.yml` instead of the correct `.github/workflows/build-release-apk.yml`). GitHub Actions only looks in the exact folder `.github/workflows/`.

**Solution**: Use the "Create new file" method from the repo root and type the **full correct path** in the filename box. This forces GitHub to create it in the right place.

---

## EXACT STEPS TO FIX (Do These Now)

### 1. Delete any old/broken workflow files first (clean up)

1. Go to your repo: https://github.com/mu-spec/revive-ai (stay on the **Code** tab).
2. Click into `.github` → `workflows`.
3. If you see `build-release-apk.yml`, click it → click the **trash can** icon (top right) → commit the deletion with message: `Delete old workflow file`.
4. If you see any extra folder inside (like `github` or another `workflows`), go inside it and delete the `build-release-apk.yml` file inside the nested folder too.
5. Commit the deletions.

### 2. Create the workflow in the **correct exact location** (most important step)

1. Make sure you are at the **root** of the repo (you should see folders: `android`, `lib`, `.github`, `pubspec.yaml`, etc.).
2. Click the green **Add file** button (top right) → **Create new file**.
3. In the big "Name your file..." box at the very top, **paste exactly this** (copy and paste the whole line):
   ```
   .github/workflows/build-release-apk.yml
   ```
   (Do not change anything — this is what forces the correct path.)

4. Delete any default text that appears in the big editor box below the filename.

5. **Copy the entire YAML below** and paste it into the editor:

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

          # 1. Overwrite settings.gradle.kts with correct Kotlin 2.0.21 (fixes Kotlin 2.1 stdlib incompatibility from fluttertoast and other plugins)
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

          # 2. Overwrite app/build.gradle.kts with NDK 27.0.12077973 (highest required by all plugins: fluttertoast, gal, google_mobile_ads, connectivity_plus, image_picker, permission_handler, share_plus, etc.) + compileSdk 36
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

6. Scroll down to the "Commit new file" section at the bottom.
7. Use this commit message:
   ```
   Fix: Create workflow in correct folder with full overwrites (Kotlin 2.0.21 + NDK 27)
   ```
8. Click the big green **Commit new file** button.

### 3. Run the workflow and check the Actions tab

1. After the commit succeeds, click the **Actions** tab at the top of the repo.
2. Refresh the page (F5 or Ctrl+R).
3. On the left side under "Workflows", you should now see **Build Release APK**.
4. Click it.
5. Click the green **Run workflow** button (top right) → select `main` branch → click **Run workflow**.

### 4. Report back

After the run finishes, reply with:
- "APK downloaded and tested on CPH2083" + results (icon, splash, FAL with your key, History Save, etc.)
- Or paste the last 20 lines of the build log if it fails.

**Important**: The file must be created using the "Create new file" method with the exact path `.github/workflows/build-release-apk.yml` typed in the filename box. This has fixed the "not showing" problem every time it happened before.

The workspace now has the correct bulletproof version (full overwrites for the NDK 27 and Kotlin 2.0.21 fixes from your last log).

Do steps 1 and 2 right now. Let me know what you see after committing and refreshing the Actions tab.