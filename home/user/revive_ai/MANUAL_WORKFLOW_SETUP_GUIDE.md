# Manual Workflow Setup Guide for ReviveAI (When Sidebar Doesn't Show)

You said you want to do your **own workflow** because "Build Release APK" is not appearing in the left sidebar.

This is a common GitHub UI caching issue. The file exists (you can access it via direct link), but the list on the left sometimes doesn't update.

Below are the **exact steps** to create/set up the workflow yourself from the GitHub UI (this is the method that usually forces it to appear).

---

## Step-by-Step: Create Your Own Workflow in the GitHub UI

### 1. Go to the Actions tab
- Open your repo: https://github.com/mu-spec/revive-ai
- Click the **Actions** tab at the top.

### 2. Start "Set up a workflow yourself"
- You should see a big screen that says **"Get started with GitHub Actions"** or **"Found 0 workflows"**.
- Look for and click the blue link:
  **"Skip this and set up a workflow yourself"**

  (If you don't see that screen, click the green **"New workflow"** button instead, then choose "set up a workflow yourself".)

### 3. Clear the editor
- GitHub will open a new file editor (usually with a default name like `.github/workflows/blank.yml` and some default YAML content).
- **Select all the text** in the big editor box and **delete everything**.

### 4. Paste the clean bulletproof YAML
Copy the **entire block** below and paste it into the empty editor:

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

### 5. Set the correct filename (very important)
- Look at the small box at the **top** of the editor (it usually says something like `.github/workflows/blank.yml` or `main.yml`).
- **Change it to exactly this**:
  ```
  .github/workflows/build-release-apk.yml
  ```

### 6. Commit the new workflow
- Scroll down to the bottom.
- In the "Commit new file" section:
  - Commit message: `Create Build Release APK workflow (bulletproof full overwrites - Kotlin 2.0.21 + NDK 27)`
- Leave the other options as default.
- Click the big green **"Commit new file"** button.

### 7. Run the workflow
1. After the commit succeeds, go back to the **Actions** tab.
2. **Hard refresh** the page 2–3 times (`Ctrl + Shift + R`).
3. Look on the left sidebar — "Build Release APK" should now appear.
4. Click it.
5. Click the green **"Run workflow"** button (top right).
6. Select branch `main` and click **Run workflow**.

---

## If It Still Doesn't Appear in the Left Sidebar After Committing

- Use the direct link you already have:
  https://github.com/mu-spec/revive-ai/actions/workflows/build-release-apk.yml
- On that page, click the green **Run workflow** button to trigger it manually.
- The build will still work even if the sidebar is slow to update.

---

## What This YAML Does (Summary)
- Uses the latest fixes we discovered:
  - Full overwrite of `settings.gradle.kts` → Kotlin 2.0.21 + AGP 8.7.0
  - Full overwrite of `app/build.gradle.kts` → `ndkVersion = "27.0.12077973"` + `compileSdk = 36`
  - Verification steps printed in the log
  - Uploads `app-release.apk` as an artifact you can download

All your features (FAL key, gal Save, premium features, manual splash, etc.) are already in the code and will be included in the build.

---

After you complete steps 2–6, reply with:
- "Workflow created and committed"
- Whether "Build Release APK" now shows in the left sidebar
- Or paste the result after you click Run workflow (success or the log)

You now have full control — this is "your own workflow" created manually in the UI.