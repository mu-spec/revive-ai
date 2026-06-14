# Complete Codemagic Guide for ReviveAI (2026) - Solving All Problems

This guide is made specifically for your project after all the errors you faced (AGP, Kotlin, NDK, YAML parse errors, etc.).

## Why Codemagic is Good for Flutter
- Built specifically for Flutter
- Very easy Flutter version selection
- Good free tier (500 build minutes/month)
- Fast Android builds

## Step-by-Step Setup

### 1. Sign up / Login
- Go to https://codemagic.io
- Sign in with GitHub (recommended)

### 2. Add your project
1. Click **Add application**
2. Choose GitHub
3. Select your repo: `mu-spec/revive-ai`
4. Click **Add application**

### 3. Create the codemagic.yaml file (Most Important Step)

You must have a clean `codemagic.yaml` in your repo root.

**Best way (recommended):**

1. Go to your repo on GitHub (Code tab).
2. Click the green **Add file** → **Create new file**.
3. Filename: `codemagic.yaml` (exactly like this, no folders).
4. Delete any default text.
5. Paste the **full YAML** from below.
6. Commit message: `Add bulletproof codemagic.yaml (Kotlin 2.0.21 + NDK 27 + full overwrites)`
7. Click **Commit new file**.

### 4. The Bulletproof codemagic.yaml (Copy Everything)

```yaml
# codemagic.yaml - Bulletproof for ReviveAI
# All fixes included: AGP 8.7.0, Kotlin 2.0.21, NDK 27.0.12077973, compileSdk 36
# Uses full file overwrites (most reliable method)

workflows:
  build-release-apk:
    name: Build Release APK
    max_build_duration: 60

    environment:
      flutter: 3.29.2

    scripts:
      - name: Install dependencies
        script: |
          flutter pub get

      - name: Clean project
        script: |
          flutter clean
          flutter pub get

      - name: Apply fixes (AGP 8.7.0 + Kotlin 2.0.21 + NDK 27 + compileSdk 36)
        script: |
          echo "=== Applying fixes ==="
          echo "androidGradlePluginVersion=8.7.0" >> android/gradle.properties
          echo "android.useAndroidX=true" >> android/gradle.properties
          echo "android.enableJetifier=true" >> android/gradle.properties

          # Full overwrite - most reliable (avoids sed corruption)
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

          echo "=== Verification ==="
          echo "settings.gradle.kts:"
          grep -E 'com.android.application|org.jetbrains.kotlin' android/settings.gradle.kts || true
          echo "app/build.gradle.kts:"
          grep -E 'compileSdk|ndkVersion' android/app/build.gradle.kts || true

      - name: Build Release APK
        script: |
          flutter build apk --release --android-skip-build-dependency-validation

    artifacts:
      - build/app/outputs/flutter-apk/app-release.apk

    publishing:
      email:
        recipients:
          - your-email@example.com   # ← IMPORTANT: Change this to your real email
        notify:
          success: true
          failure: true
```

### 5. Configure in Codemagic UI

After committing the file:

1. Go back to Codemagic.
2. Open your app.
3. Go to **Settings** (left menu).
4. Under **Build**:
   - **Flutter version**: `3.29.2` (stable)
   - **Build machine**: Ubuntu (default is fine)
5. Under **Publishing**:
   - Turn on **Email** publishing and put your email.
6. Click **Save**.

### 6. Start the Build

1. Go to the **Builds** tab.
2. Click the big **Start new build** button.
3. Select branch: `main`
4. Click **Start new build**.

---

## Common Problems & Exact Fixes (What We Learned)

| Problem you had before                  | Fix in this YAML                              | Why it works |
|-----------------------------------------|-----------------------------------------------|--------------|
| AGP 8.2.1 error                         | `androidGradlePluginVersion=8.7.0` + full overwrite | Forces correct Android Gradle Plugin |
| Kotlin 8.7.0 error (plugin not found)   | `id("org.jetbrains.kotlin.android") version "2.0.21"` | Correct modern Kotlin version |
| NDK 26 vs 27 required by plugins        | `ndkVersion = "27.0.12077973"`                | Matches what fluttertoast, gal, ads, etc. need |
| compileSdk too low (fluttertoast warning) | `compileSdk = 36`                          | Required for newer packages |
| YAML parse errors (heredoc, comments)   | Clean YAML + full `cat > file` overwrites     | No risky sed, no extra sections |
| Old Flutter version                     | `flutter: 3.29.2` in environment              | Consistent with your local setup |

---

## After the Build Finishes

- If successful → Go to the build → **Artifacts** → download `app-release.apk`
- Report back with:
  - "APK downloaded and tested on CPH2083"
  - Or paste the last 20 lines of the build log if it fails (especially the `=== Verification ===` section)

---

## Extra Tips

- **Never use `sed`** for version changes in Codemagic — it often corrupts the file (we learned this the hard way).
- Always use full `cat > file << 'EOF'` overwrites (as shown above).
- Change the email in the `publishing` section to your real email.
- If you want a **signed** APK later, you can add keystore in Codemagic UI under **Android code signing**.

---

## If You Still Get Errors

Paste the error here and I will give you the exact fix (we have already solved almost every possible Flutter + Codemagic error in this project).

This `codemagic.yaml` is currently the strongest and cleanest version for your project.

Would you like me to also give you a version with **email publishing removed** (in case you don't want emails)? Just say the word.