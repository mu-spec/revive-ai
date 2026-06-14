# ReviveAI - Exact Step-by-Step Guide (What to Do Where)

This document tells you **exactly** what to do in each phase, and **where** (in this chat / on your PC / on your phone).

## Important: Two Different Layers

- **Development Layer** → Changes in code, Settings UI, default provider, etc. (We do this here in the chat + on your Windows PC in VS Code)
- **Testing & Validation Layer** → Actually running the app, testing new modes, Premium quality, offline behavior (This **must** happen on your **real Android phone**)

---

## Recommended Sequence Right Now

### Phase 1: Make the App Usable & Professional (Do This First)

#### Step 1.1: Code Changes (Do here in this chat + on your PC)
**Location**: VS Code on your Windows laptop

Actions:
- Make **FAL AI** the default provider (recommended for fast launch).
- Clean up the Settings screen so it's not confusing for end users / your senior.
- Make sure the two external legal links are correctly set.

**I can do most of this for you right now** if you want. Just say "make FAL default and clean Settings".

After I make the changes:
1. Sync the latest files from this workspace to your local `revive_ai` folder.
2. Run these commands in your local terminal (inside `revive_ai` folder):

```bash
flutter clean
flutter pub get
```

#### Step 1.2: Get a Working AI Provider (Critical)

**Option A (Recommended for now - Fastest)**: Use **FAL AI**
- Go to https://fal.ai
- Sign up (free credits usually available)
- Get your API key
- In the app Settings → Switch provider to **FAL** → Paste key → Save

**Option B**: Use Replicate + Proxy (more secure but needs extra server work later)

#### Step 1.3: Test on Real Phone (Must do on your physical device)

**Location**: Your real Android phone (CPH2083)

You **cannot** properly test these things only in VS Code:

- New modes (Portrait Studio + Cartoon & Anime)
- Real Premium Quality difference (higher resolution + better params)
- Offline message when no internet
- App icon + manual splash screen
- Before/After slider
- History
- Ads (test ads)
- Watermark on free results

**How to test**:
1. Connect your phone via USB (already detected before).
2. Run:
   ```bash
   flutter run -d SSS8HQY9V4GMPNNR
   ```
   (or just `flutter run` and select your phone)

3. Test checklist:
   - [ ] Enhance a photo as free user → see watermark + daily limit
   - [ ] Switch to FAL provider and test
   - [ ] Test Portrait Studio and Cartoon & Anime modes
   - [ ] Turn on Premium (temporarily hardcode or use test purchase later) → check higher quality + "Premium Quality" labels
   - [ ] Turn off internet → try to enhance → should show clear offline message
   - [ ] Check History list has small premium badges on thumbnails
   - [ ] Check Result screen has "Premium Quality" indicators

---

### Phase 2: Prepare for Submission to Senior

#### Step 2.1: Build Release Version (On your PC)

Run this in your local terminal (inside `revive_ai`):

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

The file will be here:
`build\app\outputs\bundle\release\app-release.aab`

This is the file you will give to your senior for Play Store.

#### Step 2.2: Prepare Handover Message + Files

Create a short message + zip these things:
- The release `.aab` file
- Current `pubspec.yaml`
- Screenshots of new modes + Premium Quality labels
- The two legal links you already have

---

### Phase 3: What Your Senior Must Do

- Create Google Play Console product `premium_unlock`
- Set up license testing (so you can test purchases for free)
- Upload the AAB
- Add real AdMob IDs (you already have the real IDs noted in the code)
- Final store listing

---

## What You Should Do **Right Now** (Immediate Next Action)

Please reply with one of these:

**A.** "Make FAL the default + clean the Settings screen"  
→ I will update the code here. Then you sync + run `flutter pub get` + test on phone.

**B.** "Give me the exact testing checklist for my phone"  
→ I will give you a detailed test plan to run on your CPH2083 phone.

**C.** "Help me build the release AAB right now"  
→ Step-by-step commands + what to do if there are errors.

**D.** "I want to use Replicate with the proxy instead of FAL"  
→ I will guide you on deploying the small backend proxy.

---

**My personal recommendation**:

Do **A** first (I update code here), then test on your phone (Step 1.3), then build the AAB.

You are not stuck. We just need to separate "coding work" from "testing on device" clearly.

Reply with **A**, **B**, **C**, or **D** (or describe what you want to do first).