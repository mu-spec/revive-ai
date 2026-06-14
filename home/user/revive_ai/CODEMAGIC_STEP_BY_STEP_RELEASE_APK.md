# Step-by-Step: Build Release APK in Codemagic (Current UI)

This is the exact process for your ReviveAI project using the **safest** `codemagic.yaml` (the version that copies pre-written `.fixed` files).

This method completely avoids YAML parse errors like "While scanning a simple key".

---

## Prerequisites (GitHub - Do This First)

Make sure these **three files** are committed on the `main` branch:

1. `codemagic.yaml` (the safe version with `cp` commands)
2. `android/settings.gradle.kts.fixed`
3. `android/app/build.gradle.kts.fixed`

The `codemagic.yaml` must contain lines like this inside a script:

```yaml
cp android/settings.gradle.kts.fixed android/settings.gradle.kts
cp android/app/build.gradle.kts.fixed android/app/build.gradle.kts
```

Also update the email in the `publishing` section to your real email.

If these files are missing, commit them now.

---

## Step-by-Step in Codemagic (Current 2026 UI)

### 1. Open your app
1. Go to https://codemagic.io
2. Log in with GitHub.
3. Click on your app **revive-ai**.

### 2. Go to the Workflows tab
Look at the **left sidebar**. Click **Workflows**.

(This is the main configuration tab in the current UI.)

### 3. Set Flutter version
1. Click on the workflow named **Build Release APK**.
2. Find the section for **Flutter version**, **Environment**, or **SDKs**.
3. Set:
   - Flutter version: `3.29.2`
   - Channel: **stable**
4. Click **Save** (top right or bottom).

> Your `codemagic.yaml` already forces version 3.29.2, so this is mostly confirmation.

### 4. Configure Email Publishing (Recommended)
- In the **Workflows** tab (or click **Settings** on the left), look for:
  - Publishing
  - Notifications
  - Email
- Turn on Email publishing.
- Add your real email address.
- Click **Save**.

(You can also just use the `publishing:` section already in the YAML.)

### 5. Start the Build
1. Click **Builds** in the left sidebar.
2. Click the big **Start new build** button.
3. Select:
   - Branch: **main**
   - Workflow: **Build Release APK**
4. Click **Start new build**.

---

## After Starting the Build

- The build usually takes **8–15 minutes**.
- Look in the logs for the section `=== Verification ===` (it shows the fixed files were copied successfully).

### When the build finishes

**Success:**
- Scroll to the **Artifacts** section.
- Download the artifact (usually named `revive-ai-release-apk` or similar).
- Extract it → you will get `app-release.apk`.

**Failure:**
- Open the failed build.
- Copy the error message (especially anything after `=== Verification ===`).
- Paste the error here and we will fix it.

---

## After Downloading the APK

1. Install `app-release.apk` on your phone (CPH2083).
2. Test the following:
   - App icon and splash screen
   - AI enhancement using FAL with your key `f3328d24-2198-47d9-ba11-e6517e693a18:cafaec7896d7f116a4cd12d6874552ae`
   - History screen → "Save to Gallery" button (should show premium icon/text + confirmation dialog)
   - Watermark only on free (non-premium) results
   - Saving to gallery works

Then reply with something like:
> "APK downloaded and tested on CPH2083. Icon/splash good. FAL worked. History Save shows premium button + confirmation. Gallery save successful."

---

## Tips

- Always commit the three files (`codemagic.yaml` + two `.fixed` files) on `main` before starting a build.
- In the current Codemagic UI, the **Workflows** tab is where you do most settings.
- The `.fixed` + `cp` method is currently the most reliable way to avoid YAML parse errors.

---

You are now ready.

Follow the steps above and start the build.

Come back and tell me:
- "Build started"
- Any error you see
- Or the result after it finishes (especially if you downloaded the APK)

I will help you with any problem immediately.