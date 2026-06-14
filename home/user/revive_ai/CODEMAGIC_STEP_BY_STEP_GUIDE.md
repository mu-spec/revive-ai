# Step-by-Step Guide: Build Release APK using Codemagic (Updated for mu-spec)

This guide will help you build the **Release APK** of your ReviveAI app using **Codemagic** (cloud CI/CD).  
This is the easiest way for you right now because your local machine has disk space and cache problems.

**Your GitHub username: mu-spec**  
**Target repo: https://github.com/mu-spec/revive-ai.git**

---

## IMPORTANT: Your Previous Error Explained

You got two problems:
1. You pasted the markdown guide (with # comments) directly into CMD. CMD treated the # lines as commands ("# Push to GitHub" became a command).
2. The push failed with "Repository not found" pointing to YOUR-USERNAME — this happened because an old/wrong remote was still set from a previous attempt.

**Fix is below.** Follow exactly.

---

## Step 1: Create the GitHub Repository FIRST (Do This Now)

Before the push can succeed, you **must** create the empty repository on GitHub under your mu-spec account.

1. Go to https://github.com and log in with your `mu-spec` account.
2. Click the big green **+** button (top right) → **New repository**.
3. Repository name: type **exactly** `revive-ai` (all lowercase).
4. Make it **Public** or **Private** (your choice).
5. **Uncheck** "Add a README file", "Add .gitignore", and "Choose a license".
6. Click **Create repository**.

The repo will be at: https://github.com/mu-spec/revive-ai

**Do this first** if you haven't.

---

## Step 2: Run These Clean Commands in Windows CMD (No # Comments - Safe to Paste)

**Open Command Prompt** on your PC (Windows key → type "cmd" → Enter).

Then copy and paste **this entire clean block** (it has **zero # comments** inside the code so CMD will not complain):

```cmd
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

git init

git add .

git commit -m "ReviveAI - Ready for Codemagic build"

git branch -M main

git remote remove origin

git remote add origin https://github.com/mu-spec/revive-ai.git

git push -u origin main
```

**Run it now.**

**Notes:**
- The line `git remote remove origin` is safe — if it says "error: No such remote 'origin'" the first time, that's normal and good (it means it cleaned any old remote).
- When Git asks for username: type `mu-spec` and press Enter.
- When Git asks for password: type your GitHub password **or** (recommended) a Personal Access Token.
  - To make a token: On GitHub.com go to your profile → Settings → Developer settings → Personal access tokens → Tokens (classic) → Generate new token → check the "repo" box → Generate → copy the long token and paste it as the password when CMD asks.

After success you will see a message like:
`Branch 'main' set up to track remote branch 'main' from 'origin'.`

**If you still get "Repository not found" after this:**
- Confirm you created the repo on GitHub as exactly `mu-spec/revive-ai`.
- Make sure you are logged into the correct GitHub account in your browser (the one that owns mu-spec).

**After running the block, reply here with the full output from your CMD window** and write **"Git push done"** (or paste the exact error if it fails).

---

## Step 3: Update Email in codemagic.yaml (After Push Succeeds)

Once the push in Step 2 succeeds:

1. On your PC, open this file in Notepad:
   `C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai\codemagic.yaml`

2. Find this line near the bottom:
   ```
   - your-email@example.com   # ← Change this to your real email
   ```

3. Replace `your-email@example.com` with your real email address.

4. Save the file.

5. Then run these commands to commit and push the change:

```cmd
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

git add codemagic.yaml

git commit -m "Update email in codemagic.yaml for build notifications"

git push
```

---

## Step 4: Sign Up / Log In to Codemagic

1. Go to https://codemagic.io
2. Click **Sign up** (or Log in).
3. Choose **Sign in with GitHub**.
4. Authorize Codemagic to access your repositories.

---

## Step 5: Add Your Project to Codemagic

1. After logging in, click the big **Add application** button.
2. Select your GitHub account (**mu-spec**).
3. Find and select the repository named **revive-ai**.
4. Click **Next**.
5. Codemagic should automatically detect the `codemagic.yaml` file.
6. Choose **Flutter** as the project type.
7. Click **Finish: Add application**.

---

## Step 6: Start the Build

1. On the app dashboard you will see the workflow: **Build Release APK**.
2. Click the **Start new build** button.
3. Select the `main` branch.
4. Click **Start build**.

Codemagic will build the release APK in the cloud (usually 8-15 minutes).

---

## Step 7: Download the APK

1. Wait for **Success** (green status).
2. Scroll to **Artifacts**.
3. Click `app-release.apk` to download it.

---

## Step 8: Install on Your Phone (CPH2083) and Test

1. Copy the APK to your phone.
2. Uninstall any old ReviveAI version.
3. Install the new APK.
4. Test:

   - App icon correct
   - Custom splash screen (your manual assets)
   - FAL enhancement (your key: f3328d24-2198-47d9-ba11-e6517e693a18:cafaec7896d7f116a4cd12d6874552ae)
   - History Save button shows loading + confirmation dialog
   - Premium Save button text/icon difference
   - Save to Gallery works
   - Watermark only on free results
   - Modern UI, no login, Netlify links

**Reply after testing with:**
"APK downloaded and tested"
Then list what worked and what didn't.

---

## Optional: Signed APK Later

Current build = unsigned (fine for testing on your phone).

For Play Store: add keystore in Codemagic Code signing tab later.

---

## Common Fixes

- "#" command error → Use the clean block in Step 2 (no # inside).
- Repository not found → Create repo on GitHub first (Step 1), then clean block.
- remote origin already exists → The block already has `git remote remove origin`.
- Need token for push → Instructions in Step 2.

All your previous features are preserved exactly (FAL with your key, gal Save with premium dialog/icon, watermark only on free, etc.).

**Right now: Create the repo on GitHub (Step 1), then run the clean block in Step 2.**

Reply with the CMD output! 🚀