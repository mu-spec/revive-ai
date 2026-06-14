# Manual Splash Screen Setup for ReviveAI (Android Only)

Since the flutter_native_splash package had persistent bugs on your machine, we are setting up the splash screen manually using your custom images.

You have two images to use:
- `splash_background.png` → Full background (photo frames design)
- `splash_logo.png` → Centered logo (blue silhouette with "ReviveAI")

## Step 1: Copy Images to Android Resources

1. Open your local project folder:
   `C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai`

2. Go to this folder (create it if it doesn't exist):
   `android/app/src/main/res/drawable`

3. Copy these two files from your `assets/images/` folder into the `drawable` folder:
   - `splash_background.png`
   - `splash_logo.png`

   (You can keep the same names.)

## Step 2: Create a Splash Drawable (Layer List)

1. In the same `drawable` folder, create a new file called:
   `splash.xml`

2. Paste the following content into it:

```xml
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Background layer -->
    <item android:drawable="@drawable/splash_background" />

    <!-- Centered logo layer -->
    <item>
        <bitmap
            android:gravity="center"
            android:src="@drawable/splash_logo" />
    </item>
</layer-list>
```

This creates a splash that shows your background image with the ReviveAI logo perfectly centered on top.

## Step 3: Update the Launch Theme

### For all Android versions:

1. Open:
   `android/app/src/main/res/values/styles.xml`

2. Find the `<style name="LaunchTheme" ...>` block and add the windowBackground line:

```xml
<style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
    <!-- Show your custom splash drawable as soon as the app starts -->
    <item name="android:windowBackground">@drawable/splash</item>
    <!-- ... other items ... -->
</style>
```

### For Android 12 and above (recommended):

1. Open (or create if missing):
   `android/app/src/main/res/values-v31/styles.xml`

2. Add or update the LaunchTheme:

```xml
<style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
    <item name="android:windowBackground">@drawable/splash</item>
    <!-- Android 12+ splash screen specific -->
    <item name="android:windowSplashScreenBackground">#1565C0</item>
</style>
```

## Step 4: Clean and Rebuild

In your terminal (inside the `revive_ai` folder):

```bash
flutter clean
flutter pub get
flutter run
```

The first time you launch the app, you should see your custom splash screen (background + centered logo) instead of the default white one.

## Optional: Make the Splash Last a Bit Longer (if it disappears too fast)

You can add a short delay in `main.dart` before `runApp()`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Optional: Keep splash visible a little longer
  await Future.delayed(const Duration(milliseconds: 800));
  
  // Initialize other things (PurchaseService, etc.)
  ...
  runApp(...);
}
```

## Notes

- This manual method only affects Android (which is what we want, since the project is Android-only).
- For production, consider putting properly sized versions of the images in different density folders (`drawable-mdpi`, `drawable-hdpi`, etc.) for better performance on all devices.
- The splash will automatically disappear once Flutter has finished initializing and your first screen is ready.

If you want to change the logo size, position, or add a small tagline later, just edit the `splash.xml` layer-list.

Let me know if you want any adjustments (e.g., bigger logo, different gravity, or adding the "Restore Old Memories" tagline as text).