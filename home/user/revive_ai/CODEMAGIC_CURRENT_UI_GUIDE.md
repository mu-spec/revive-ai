# Codemagic Current UI Guide (2026) - For Your Situation

You went to **Settings** but could not find the old steps:
- "Environment → Flutter version"
- "Publishing → Email"

**Reason**: Codemagic updated their interface in 2025-2026. Many settings moved into the `codemagic.yaml` file. This is actually better because the file is version-controlled.

The clean `codemagic.yaml` we gave you already contains:
- `flutter: 3.29.2`
- All fixes (Kotlin 2.0.21, NDK 27.0.12077973, compileSdk 36, AGP 8.7.0)
- Full file overwrites (this is why it is reliable)
- Email publishing

You only need to do a few things in the current UI.

---

## Exact Steps with Current UI

### 1. Open your app
1. Go to https://codemagic.io
2. Log in with GitHub.
3. Click on your app **revive-ai**.

### 2. Look at the left sidebar (this is the key)

In the current UI the left sidebar usually shows:

- Overview
- Builds
- **Workflows**   ← **Click this** (most important tab now)
- Settings
- Integrations

**Action**: Click **Workflows** on the left sidebar.

### 3. Configure Flutter Version

1. In the Workflows tab, click on the workflow named **Build Release APK**.
2. Look for sections like:
   - Environment
   - SDK versions
   - Flutter version
3. Set **Flutter version** to `3.29.2` (stable channel).

**Even if you don't see this option**, your `codemagic.yaml` already forces it with this line:

```yaml
environment:
  flutter: 3.29.2
```

This is usually enough.

### 4. Email Publishing

**Easiest way (Recommended)**:  
The `publishing:` section is already in the `codemagic.yaml`. It will send emails automatically when the build succeeds or fails. You don't need to change anything in the UI.

**If you want to configure in UI**:
- While in the Workflows tab (or click **Settings** on the left), look for:
  - Publishing
  - Notifications
  - Email
- Turn on Email publishing and add your real email.
- Click **Save**.

### 5. Save your changes

Click the **Save** button (top right or bottom). It may say "Apply" or "Save workflow".

### 6. Start the Build

1. Click **Builds** in the left sidebar.
2. Click the big **Start new build** button.
3. Select branch: **main**
4. Select the workflow: **Build Release APK** (if shown).
5. Click **Start new build**.

---

## Summary - What You Need to Do Right Now

1. Make sure the clean bulletproof `codemagic.yaml` is committed to GitHub.
2. Go to **Workflows** tab (not the old Settings path).
3. Set Flutter 3.29.2 if the option is visible.
4. Click **Save**.
5. Go to **Builds** tab and start the build.

The real fixes for your previous errors are already inside the YAML.

---

## If You Still Can't Find the Options

Please reply with **exactly** what you see on the left sidebar when you open the app.

Example:
"I see on the left: Overview, Builds, Workflows, Settings, Integrations"

I will then give you more precise clicks for the current screen.

---

## Want a Simpler YAML?

If the publishing section is confusing you, reply with:

**"give yaml without email"**

I will immediately give you a clean version of `codemagic.yaml` without the publishing part.

---

You are ready. Follow the steps above and start a build. Then come back and tell me:
- Did the build start?
- Any error?
- Or paste the first 15-20 lines of the log.

We will solve whatever appears.