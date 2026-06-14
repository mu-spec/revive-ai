# Release Signing (Keystore) — Required for Play Store & Real IAP Testing

## What This Means
Currently the release build uses **debug signing** (`signingConfig = signingConfigs.getByName("debug")`).

This is fine for:
- Sideloading the APK on your own phone (CPH2083)
- Quick testing

It is **not acceptable** for:
- Uploading to Google Play Console (Play Store rejects debug-signed apps)
- Real internal testing tracks (required before you can test real IAP purchases)
- Production release

**"Scaffolding ready"** means:
- The full `signingConfigs { create("release") { ... } }` block already exists in `android/app/build.gradle.kts.fixed`
- Clear comments tell you exactly what to do
- Codemagic has a dedicated "Code signing" tab that makes this easy
- You just need to generate one keystore file and upload it

This is a **one-time** task. Once done, all future builds can be properly signed.

---

## Step-by-Step: Generate Keystore and Upload to Codemagic

### 1. Generate the Keystore on Your Windows PC (Do This Once)

Open Command Prompt and run these commands **exactly**:

```cmd
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai\android\app"

keytool -genkey -v -keystore reviveai-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias reviveai
```

When it asks questions:
- Keystore password: choose a strong one and remember it (or write it down securely)
- Key password: can be the same as keystore password
- First and last name: your name or company
- Organizational unit: ReviveAI
- Organization: Your name or "Personal"
- City, State, Country code: fill reasonably

It will create the file:
`C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai\android\app\reviveai-release-key.jks`

**Keep this .jks file safe forever.** If you lose it, you cannot update your app on Play Store later.

### 2. Upload the Keystore to Codemagic (One-Time)

1. Go to https://codemagic.io and open your ReviveAI app.
2. Click the **Code signing** tab (left sidebar).
3. Under **Android keystores**, click **Add keystore**.
4. Upload the file `reviveai-release-key.jks`
5. Fill:
   - **Keystore password**: the one you chose
   - **Key alias**: `reviveai`
   - **Key password**: the one you chose
6. Click **Add keystore**.

Codemagic will now be able to sign release builds automatically.

### 3. Update the Build Config (Already Prepared)

The file `android/app/build.gradle.kts.fixed` already contains the correct block (you just need to uncomment when ready).

For now it stays on debug so you can keep testing unsigned APKs easily.

When you are ready for signed builds for Play Console, we will change one line (I can give you the exact edit later).

### 4. Build a Signed Release in Codemagic

After uploading the keystore:
1. Start a new build in Codemagic (Build Release APK or change to AAB later).
2. In the build logs you should see it using the release signing config.
3. Download the signed APK/AAB.

### 5. Upload to Play Console

Use the signed AAB (preferred) or APK for:
- Internal testing track (needed for real IAP testing)
- Closed / Open testing
- Production

---

## Important Warnings

- Never commit the `.jks` file or passwords to GitHub.
- The keystore file must be backed up in a safe place (Google Drive, password manager, etc.).
- Once you publish with this keystore, you **must** use the exact same one for all future updates.

---

## What I Have Already Done for You

- Added complete `signingConfigs { create("release") }` block with instructions.
- Added comments explaining when to switch from debug.
- Kept current behavior as debug so your phone testing remains easy.
- Updated `RELEASE_BUILD_INSTRUCTIONS.md` (if present) with references.

After you generate the keystore and upload it to Codemagic, reply here with:
"Keystore generated and uploaded to Codemagic"

Then tell me if you want to switch the build to use the release signing config for the next build.

This is a standard one-time security step required by Google for any app that will be on the Play Store.