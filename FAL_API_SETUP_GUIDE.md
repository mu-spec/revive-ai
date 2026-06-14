# Step-by-Step Guide: Get FAL API Key and Make FAL the Working Provider

This is the **easiest and fastest** way to make your app have real, working AI enhancement right now (no backend server needed).

---

## Step 1: Create a FAL AI Account and Get Your API Key

1. Open your browser and go to:  
   **https://fal.ai**

2. Click on **"Sign up"** (top right).

3. Sign up using **Google** (easiest) or GitHub.

4. After logging in, you will be taken to the dashboard.

5. On the left sidebar, click on **"API Keys"** (or go directly to: https://fal.ai/dashboard/keys).

6. Click the button **"Create new key"** or **"+ New Key"**.

7. Give it a name like `ReviveAI` (optional) and click **Create**.

8. **Copy the key** immediately.  
   It will look something like: `fal_key_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

   **Important**: You can only see the full key once. Save it somewhere safe.

---

## Step 2: Put the FAL Key into Your App

### Option A: While Developing (on your PC + phone)

1. Make sure your phone is connected and the app is running (`flutter run`).

2. Open the app on your phone → go to **Settings** tab.

3. You should see sections like:
   - AI Provider
   - FAL AI API Key

4. In the **"FAL AI API Key"** field, paste the key you copied from fal.ai.

5. Tap **"Save FAL Key"**.

6. Now change the **AI Provider** dropdown to **"fal"** (or "FAL").

7. The app will now use FAL AI for all enhancements.

### Option B: After you build the app (for testing the release version)

- Install the APK/AAB on your phone.
- Open Settings → enter the FAL key and switch provider to FAL (same as above).

---

## Step 3: Test That FAL Is Working

1. Go to the **Enhance** tab.

2. Select a photo.

3. Choose any mode (try **"Portrait Studio"** or **"Cartoon & Anime"** — these are new and look impressive).

4. Tap **"Enhance Photo with AI"**.

5. You should see status messages like:
   - "Uploading to FAL AI..."
   - "Downloading from FAL..."

6. After it finishes, go to the Result screen and check:
   - If you are testing as Premium → you should see **"Premium Quality"** label.
   - The result should be a real enhanced photo from FAL.

**If it works** → Congratulations! You now have a real, working AI provider in the app.

---

## Step 4: (Recommended) Make FAL the Default Provider in Code

So that new users / your senior don't have to manually switch every time.

**Do this on your Windows PC:**

1. Open the project in VS Code.

2. I can update the code for you right now if you want.  
   Just reply with: **"Make FAL the default provider in code"**

   Or manually:
   - In `lib/services/ai_provider_service.dart`, change the default in the class.
   - In `lib/screens/settings_screen.dart`, set the initial dropdown value to `AIProvider.fal`.

---

## Common Issues & Fixes

| Problem | Solution |
|--------|---------|
| "FAL AI error" or key not working | Make sure you copied the **full** key (starts with `fal_key_...`) |
| App still using old provider | Go to Settings → change "AI Provider" to FAL and save |
| No internet error | FAL also needs internet. Turn on mobile data/WiFi |
| Slow or fails | FAL sometimes has queue. Try a smaller image or wait 10-20 seconds |

---

## Next Actions After This Works

1. Test all modes on your real phone (especially new ones).
2. Test Premium Quality difference (temporarily force `isPremium = true` for testing).
3. Build release AAB.
4. Send to your senior with the two Netlify legal links.

---

**Would you like me to do any of these right now?**

- Update the code so **FAL is the default provider** automatically.
- Simplify the Settings screen (remove confusing Replicate/Proxy options for now).
- Give you the exact testing checklist for your phone after you add the FAL key.

Just reply with what you want next.