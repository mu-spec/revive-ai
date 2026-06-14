# Step-by-Step Guide: Build Release APK using Codemagic

This guide will help you build the **Release APK** of your ReviveAI app using **Codemagic** (cloud CI/CD).  
This is the easiest way for you right now because your local machine has disk space and cache problems.

---

## Step 1: Push Your Project to GitHub (Required)

Codemagic works with GitHub. You must upload your project first.

### On your Windows PC, run these commands:

```bash
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

# Initialize git (if not done before)
git init

# Add all files
git add .

# Commit the code
git commit -m "ReviveAI - Ready for Codemagic build"

# Rename branch to main
git branch -M main

# Add your GitHub repository (replace with your actual link)
git remote add origin https://github.com/YOUR-USERNAME/revive-ai.git

# Push to GitHub
git push -u origin main
```

**Important**:
- Replace `YOUR-USERNAME` with your actual GitHub username.
- If your repo is private, you may need to use a **Personal Access Token** instead of password.
- If you get any error, tell me the exact message.

---

## Step 2: Create / Update codemagic.yaml

We have already created a good `codemagic.yaml` file for you.

Make sure the file exists at the root of your project with this content:

```yaml
# codemagic.yaml
workflows:
  android-release-apk:
    name: Build Release APK
    max_build_duration: 60

    environment:
      flutter: stable

    scripts:
      - name: Install dependencies
        script: |
          flutter pub get

      - name: Clean project
        script: |
          flutter clean
          flutter pub get

      - name: Build Release APK
        script: |
          flutter build apk --release --android-skip-build-dependency-validation

    artifacts:
      - build/app/outputs/flutter-apk/app-release.apk

    publishing:
      email:
        recipients:
          - your-email@example.com     # ← Change this to your real email
        notify:
          success: true
          failure: true
```

**Action**: Open the file and change `your-email@example.com` to your actual email address.

---

## Step 3: Sign Up on Codemagic

1. Go to: [https://codemagic.io](https://codemagic.io)
2. Click **Sign up**.
3. Choose **Sign in with GitHub**.
4. Authorize Codemagic to access your repositories.

---

## Step 4: Add Your Project to Codemagic

1. After logging in, click the big **Add application** button.
2. Select your GitHub account.
3. Find and select your `revive-ai` repository.
4. Click **Next**.
5. Codemagic should automatically detect the `codemagic.yaml` file.
6. Choose **Flutter** as the project type.
7. Click **Finish: Add application**.

---

## Step 5: Start the Build

1. On the app dashboard, you will see your workflow: **Build Release APK**.
2. Click the **Start new build** button.
3. Choose the `main` branch.
4. Click **Start build**.

Codemagic will now:
- Download your code
- Install Flutter
- Run `flutter pub get`
- Build the Release APK

This usually takes **8 to 15 minutes**.

---

## Step 6: Download the APK

1. Wait until the build shows **Success** (green).
2. Scroll down to the **Artifacts** section.
3. Click on `app-release.apk` to download it.

You now have a proper **Release APK** built in the cloud!

---

## Step 7: Install on Your Phone

1. Copy the downloaded `app-release.apk` to your CPH2083 phone.
2. Uninstall any old version of ReviveAI.
3. Install the new APK.
4. Test:
   - App icon
   - Custom splash screen
   - FAL key + enhancement
   - History Save button + confirmation dialog

---

## Optional: Get a Signed APK (Later)

Right now you will get an **unsigned** release APK (good for testing).

To get a **signed** APK (required for Play Store):

1. In Codemagic, go to your app → **Code signing**.
2. Upload your keystore file + password.
3. Update the `codemagic.yaml` to use the keystore.
4. Rebuild.

We can do this later when you are ready to publish.

---

## Common Issues & Fixes

| Problem | Solution |
|---------|----------|
| Build fails with "No codemagic.yaml" | Make sure the file is in the root of your repo |
| Email not received | Check spam folder or update email in codemagic.yaml |
| Build takes too long | Normal on free tier. Be patient. |
| Want to rebuild | Just push a new commit or click "Start new build" again |

---

## Next Steps After Successful Test

Once you download and test the APK on your phone, reply with:

- “APK downloaded and tested”
- Tell me what worked (icon, splash, FAL, History Save, etc.)

Then we can decide the next action:
- Fix any bugs
- Prepare signed APK
- Move toward Play Store submission

---

**You are ready!**

Start from **Step 1** (push to GitHub) and go step by step.

If you get stuck at any point (especially pushing to GitHub), just copy the error and paste it here. I will help you immediately.

Good luck! 🚀

---

Would you like me to also give you a ready-to-use GitHub push command block customized for your username? Just tell me your GitHub username.