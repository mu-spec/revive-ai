# Full Physical Device Testing on CPH2083 — You Must Run This

## What This Means
All the code, icons, splash, features, and logic are implemented and have been tested in the cloud build environment.

However, **only real device testing on your actual phone (CPH2083)** can confirm:
- The app actually opens when you tap the icon (you reported "nothing happens" before)
- The launcher icon looks sharp (not blurred)
- The custom splash screen appears
- FAL AI calls work with your exact key
- Save to Gallery (using gal package) actually saves to your phone's real Gallery
- Premium UI differences are visible
- Watermark appears only on free results
- Batch processing works
- Ads behave correctly
- No crashes on real hardware, real storage permissions, real network, etc.

This is why it is still marked as "Checklist ready — You must run on CPH2083 and report".

I have given you the checklist many times. Here it is in one clean, final document you can follow exactly.

---

## Preparation (Do This Every Time Before Testing a New APK)

1. On your phone: **Completely uninstall** any previous ReviveAI version.
2. Download the latest `app-release.apk` from Codemagic.
3. Install it.
4. When it asks for permissions, grant **Photos and videos** (or Storage) + Internet.
5. Make sure your phone has internet (FAL AI and ads require it).

---

## Full Test Checklist — Run in This Exact Order

### 1. Icon + Splash + Launch (Most Important for Previous "App Not Opening" Issues)

- [ ] Launcher icon on home screen and app drawer looks sharp, correct size, with proper blue background (not blurred, not the old splash logo directly).
- [ ] Tap the icon.
- [ ] Custom branded splash screen appears immediately (your splash_logo centered on splash_background).
- [ ] App fully opens to the Enhance tab with no black screen, no crash, no "nothing happens", and no force close.

**Report this section first** if it fails.

### 2. Core Enhancement Flow with Your Real FAL Key

- [ ] Go to Settings.
- [ ] Confirm "FAL" is the selected provider.
- [ ] Your exact key is visible or pre-filled: `f3328d24-2198-47d9-ba11-e6517e693a18:cafaec7896d7f116a4cd12d6874552ae`
- [ ] Go back to Enhance tab.
- [ ] Pick any old/damaged photo from your gallery.
- [ ] Select a mode (recommended first test: "Old Photo Restore").
- [ ] Tap "Enhance Photo with AI".
- [ ] Watch the real status messages ("Uploading to FAL AI...", "Downloading enhanced image...").
- [ ] Result screen opens with the real Before/After slider (drag it — it must move smoothly).

### 3. History + Save to Gallery (gal package + Premium Logic)

- [ ] Go to History tab.
- [ ] You should see the result you just created.
- [ ] For a free result:
  - Normal download icon
  - Tooltip or label says "Save to Gallery"
- [ ] (If you have Premium or can simulate it) For a premium result:
  - Amber crown badge on the thumbnail
  - "Premium Quality" amber pill/label
  - Amber `workspace_premium` icon on the save button
- [ ] Tap the Save button on any item.
- [ ] Confirmation dialog must appear with correct text:
  - Free: "Save to Gallery?"
  - Premium: "Save Premium Quality Result?"
- [ ] Tap Save.
- [ ] You must see green snackbar: "Saved to Gallery successfully!"
- [ ] Open your phone's actual **Gallery** app (or Google Photos).
- [ ] The image must be there.
- [ ] Free results must have the red "ReviveAI Free" watermark in the corner.
- [ ] Premium results must have **no** watermark.

### 4. Watermark Only on Free Results

- [ ] Confirm from the saved Gallery images above.
- [ ] Free enhancements → watermark present.
- [ ] Premium enhancements → no watermark.

### 5. Batch Processing (Premium Feature)

- [ ] This button only appears if Premium is unlocked.
- [ ] Select multiple photos in Enhance screen.
- [ ] Tap "Batch Enhance Multiple Photos (Premium)".
- [ ] It should process them one by one with progress.
- [ ] All results should appear in History with correct premium badges.

### 6. Premium / IAP Flow (Foundation Test)

- [ ] Go to Settings.
- [ ] Tap the "Unlock Premium" or similar button.
- [ ] It should open the real Google Play purchase sheet (or show "product not found" — this is expected until you create the product in Play Console).
- [ ] If you are using a license tester account and the product exists, complete a test purchase.
- [ ] After success, go back to the app — batch button should appear, ads should disappear, save buttons should show premium styling.

### 7. Ads Behavior

- [ ] On a free account: Banner ad should appear on the Result screen.
- [ ] Interstitial or rewarded ads should trigger at the right moments.
- [ ] After unlocking Premium (real or simulated): No ads should appear anywhere.

### 8. Other Real Features

- [ ] Daily limit: On free account, after 5 enhancements you should see the paywall dialog.
- [ ] Offline: Turn off internet → try to enhance → clear message that internet is required.
- [ ] Legal links in Settings open the external Netlify pages (privacy + terms).
- [ ] No login screen anywhere.
- [ ] Share button works from Result screen.
- [ ] Delete from History works with confirmation.
- [ ] App feels responsive and modern (no obvious bugs after the recent icon/splash fixes).

---

## How to Report Results (Use This Exact Format)

Copy and paste this after you finish testing:

```
APK tested on CPH2083 - [put today's date]

=== Icon + Splash + Launch ===
Icon appearance: [sharp/good | blurred | wrong]
Splash screen: [shows correctly | black | nothing]
App opens from icon: [yes | no — describe exactly what happens]

=== FAL + Enhancement ===
FAL with your exact key: [success | error message]
Before/After slider: [works | broken]

=== History + Save to Gallery ===
Save confirmation dialog appears: [yes — correct text | no]
Gallery save (gal) actually saves to phone Gallery: [yes | no / permission error]
Watermark only on free results: [yes | no]

=== Premium UI differences ===
Amber "Premium Quality" badge + icon on premium items: [yes | no]

=== Batch ===
Batch button visible only for premium: [yes | no]
Batch processing works: [yes | error]

=== IAP / Premium flow ===
Purchase button behavior: [opens Play sheet | "product not found" | other]

=== Ads ===
Ads show for free users: [yes | no]
Ads hidden for premium: [yes | no]

=== Other issues found ===
[list any crashes, weird behavior, missing features, etc.]

Overall: Ready for Play Store testing? [yes / needs fixes]
```

---

## Why This Step Is Still Open

You have reported "app was not opening" and "icon was blurred" on previous versions. We have since fixed:
- All splash + launcher icon generation (proper adaptive + brand background)
- Manual splash system
- Resource filename issues

**Only a fresh test on your physical CPH2083 after the next clean build can confirm these are resolved.**

Please run the checklist above on the next APK you build after pushing the latest workspace files.

After you send the report in the format above, we can mark this item as complete.

---

**I cannot run this for you** — it requires your physical phone. But the checklist, instructions, and all the code fixes are ready.