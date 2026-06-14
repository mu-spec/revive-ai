# ReviveAI - AI Photo Restore & Enhance

**Bring old memories back to life.** 

A professional Flutter Android app for restoring old photos, enhancing faces, colorizing B&W images, removing blur, upscaling to HD, and cleaning backgrounds using state-of-the-art AI models via [Replicate](https://replicate.com).

Built exactly according to the app idea/PRD provided by the senior developer:
- Core features: One-Tap Auto Enhance, Old Photo Restore, Face Enhance, Colorize B&W, Unblur & Upscale, Background Cleanup
- Strong Before/After comparison slider (critical for marketing)
- Clean, emotional UI focused on "Restore Old Memories"
- Fast results, realistic enhancement
- History of enhancements
- Monetization: Free tier (limited daily + ads + watermark on results), Premium (unlimited + no ads + batch processing)
- Tech: Flutter (Android only) + Replicate AI APIs (recommended for v1, no GPU server needed)

## Features Implemented (MVP v1)

✅ **Enhance Tab**
- Pick from gallery or camera
- 5 enhancement modes with descriptions
- Real-time status during AI processing
- Automatic daily limit enforcement (5 free)

✅ **Result Screen**
- Interactive Before/After slider (drag to compare)
- Share to social (TikTok/IG ready)
- Save to device
- Delete from history

✅ **History Tab**
- List of all past enhancements with thumbnails
- Tap to re-open with slider
- Clear all

✅ **Settings**
- Replicate API key input + save (securely in prefs)
- "Get Token" button linking to replicate.com
- Real In-App Purchase button for Premium (buy + restore via Google Play)
- Daily usage tracker
- About & links

✅ **Monetization Ready**
- Free: limited daily + encourage upgrade
- Premium (real IAP "premium_unlock"): unlimited + no ads + no watermark + batch processing (requires Play Console setup)

✅ **Other**
- Image compression before upload (saves cost/bandwidth)
- Local storage of results (no cloud needed for history)
- Professional blue/teal Material 3 UI
- Emotional copy throughout ("Restore Old Memories")

## Recommended Tech Stack Used
- **Frontend**: Flutter + Dart (as strongly recommended)
- **AI Backend**: Replicate APIs (flux-kontext restore, CodeFormer, DDColor) - easiest & fastest for v1 as per document. No self-hosting.

## Setup & Run

1. **Get Replicate API Token** (free credits available):
   - Go to https://replicate.com/account/api-tokens
   - Sign up (GitHub), create token (starts with `r8_...`)

2. **Run the app**:
   ```bash
   cd revive_ai
   flutter pub get
   flutter run
   ```
   - On Android emulator or physical device (strongly recommended — use a real device for testing ads)

3. **In the app**:
   - Go to **Settings** tab
   - Paste your Replicate token and **Save API Key**
   - Go to **Enhance** tab
   - Pick a photo (old damaged one works best!)
   - Choose a mode (try "Old Photo Restore" or "Colorize")
   - Tap "Enhance Photo with AI"
   - Watch the before/after slider!

**Note on costs**: Each enhancement costs a few cents on Replicate (see their pricing). Start with free credits.

## Next Steps / Production Polish (v1.1+)
- Add real In-App Purchases (in_app_purchase package) for Premium
- Direct save to Photos gallery (image_gallery_saver or photo_manager)
- Support more models (GFPGAN, Real-ESRGAN, newer 2026 models)
- Video enhancement (future expansion as suggested)
- Analytics, crash reporting
- Play Store publishing assets (icons, screenshots with before/after)
- Backend proxy for API key (for security in production)
- Offline fallback / cached results
- iOS support (if you decide to expand later)

## App Icon & Splash Screen (Newly Added + Adjusted)

Custom professional assets (generated from your provided designs):

- `assets/images/app_icon.png` — Main launcher icon (beautiful before/after face transformation)
- `assets/images/splash_logo.png` — Main splash logo (blue silhouette with "ReviveAI")
- `assets/images/splash_background.png` — Splash background (photo frames design)
- `assets/images/splash_branding.png` — Small branding image with tagline "Restore Old Memories" (for bottom of splash)

### Adjustments Made to Splash
- Switched to **branding mode** so the logo appears smaller and positioned at the bottom (less overwhelming).
- Added subtle tagline **"Restore Old Memories"** via the branding image.
- Background uses your photo frames design.
- Main splash logo still visible but the overall splash now feels more balanced and professional.

To apply / re-apply on your local machine:

1. Make sure all four PNG files are in `assets/images/`
2. Run these commands:
   ```bash
   flutter clean
   flutter pub get
   flutter pub run flutter_launcher_icons
   flutter pub run flutter_native_splash:create
   ```
3. Test with `flutter run`

See `flutter_launcher_icons.yaml` and `flutter_native_splash.yaml` for the current configuration.

If you want the logo larger or centered instead of bottom branding, just edit `flutter_native_splash.yaml` and re-run the splash command.

## File Structure
```
lib/
├── main.dart                 # App entry + bottom nav
├── models/
│   ├── enhancement_mode.dart
│   └── history_item.dart
├── screens/
│   ├── enhance_screen.dart   # Main picker + modes
│   ├── history_screen.dart
│   ├── result_screen.dart    # Before/after + actions
│   └── settings_screen.dart
├── services/
│   ├── replicate_service.dart # AI integration + polling + compress
│   └── history_service.dart   # Local storage + limits + premium
└── widgets/
    └── enhancement_card.dart
```

This is a **complete, runnable first version** of the app as described in the document. Ready for testing, iteration, and publishing.

For any questions or to add features (e.g. more AI models, real monetization), just ask!

## Legal Documents

We have created **three versions** of the legal documents:

### 1. Markdown (for editing & GitHub)
- `PRIVACY_POLICY.md`
- `TERMS_OF_SERVICE.md`

### 2. Bundled in the App (shown inside Settings → Legal)
- `assets/legal/privacy_policy.md`
- `assets/legal/terms_of_service.md`

### 3. HTML Versions (Ready for External Hosting)
Located in the `/legal` folder:
- `legal/privacy.html`
- `legal/terms.html`

These HTML files are:
- Self-contained (use Tailwind CSS via CDN)
- Professional, clean, and mobile-friendly
- Ready to upload to any static hosting (GitHub Pages, Netlify, Vercel, etc.)

**Recommended hosting URLs:**
- Privacy: `https://yourdomain.com/legal/privacy.html`
- Terms: `https://yourdomain.com/legal/terms.html`

**How to host quickly:**
1. Upload the entire `legal/` folder to Netlify, Vercel, or GitHub Pages.
2. Or simply upload the two `.html` files.

Once hosted, you can update the in-app links in `settings_screen.dart` and `legal_screen.dart` to open the web versions instead of (or in addition to) the bundled ones.

These documents are written to be production-ready and account for:
- Direct image transmission to Replicate (no server-side storage by us)
- User-provided API keys
- Local-only history storage
- AI-generated content disclaimers
- International users and children’s privacy

**For App Store / Play Store submission**: Hosting the HTML versions on a public website is strongly recommended.
