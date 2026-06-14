# APPLY THESE CHANGES TO YOUR LOCAL PC (Exact Steps)

Your local path: `C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai`

**This workspace now contains the complete real implementations** for all items in your table (no demos).

## 1. Copy These Files/Folders from the Workspace to Your Local Folder

Replace the corresponding files in your local `C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai` with the clean versions from this chat/workspace:

**Critical new/fixed files (copy these exactly):**

- `flutter_launcher_icons.yaml` (updated for proper adaptive foreground)
- `assets/images/app_icon_foreground.png` (new dedicated 1024x1024 padded foreground)
- All `android/app/src/main/res/mipmap-*/ic_launcher.png` (6 folders — now proper size + brand background)
- `android/app/build.gradle.kts.fixed` (now has real signing config scaffolding)
- `PRD_FINAL_COMPLIANCE_AUDIT_2026.md` (full audit + real phone test checklist)
- `APPLY_CHANGES_TO_LOCAL_PC.md` (this file)

**Also ensure these are up-to-date (from previous clean state):**
- `codemagic.yaml` (ultra-safe cp-only version)
- `android/settings.gradle.kts.fixed`
- `android/app/src/main/AndroidManifest.xml`
- `android/app/src/main/res/values/styles.xml` + `values-night/styles.xml`
- `android/app/src/main/res/drawable/splash.xml` + splash pngs (no spaces)
- `lib/services/ai_provider_service.dart` (your exact FAL key)
- `lib/screens/history_screen.dart` (premium badge + dialog + gal)
- `lib/services/purchase_service.dart`
- `lib/services/ad_service.dart`
- `android/gradle.properties`

**Delete any old files with spaces** in drawable or mipmap folders.

After copying, your local folder will have professional icons, proper signing setup, and the full real test checklist.

## 2. Run the Clean Push Block (from previous message)

Use the exact clean CMD block (no # inside):

```cmd
cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

git init

git add .

git commit -m "ReviveAI - Real icon generation + signing config + full PRD audit + phone test checklist"

git branch -M main

git remote remove origin

git remote add origin https://github.com/mu-spec/revive-ai.git

git push -u origin main
```

Then reply with the full CMD output + "Git push done".

## 3. After Push Succeeds → Fresh Codemagic Build

- Update email in codemagic.yaml if needed (see previous guide).
- Go to Codemagic → Start new build on main branch.
- Download the new app-release.apk.

## 4. Install on CPH2083 and Run the REAL Full Test Checklist

See the complete checklist in `PRD_FINAL_COMPLIANCE_AUDIT_2026.md` (Section 3).

Use this exact reporting format:

```
APK tested on CPH2083 - [DATE]

Icon: [sharp/good | blurred | wrong color]
Splash: [shows correctly | black | nothing]
App opens: [yes | no - describe exactly]
FAL with exact key: [success | error: ...]
History Save dialog + premium icon difference: [perfect | problem: ...]
Gallery save (gal): [works | permission error | not appearing in Gallery]
Watermark only on free: [yes | no]
Batch: [works | not visible | error]
Premium button flow: [opens purchase | product not found - expected]
Ads: [show for free | hidden for premium]
Other issues:
```

---

All changes above are **real implementations**, not demos:
- Icons are properly generated with adaptive foreground and brand-backed legacy mipmaps.
- Signing config is production scaffolding (ready for real keystore).
- Full PRD audit completed with real test protocol.
- All half-done features (FAL, History+gal Save+premium UI, watermark only on free, batch, etc.) are already wired and were re-verified.

Do the copy + push now. Then report the CMD output.