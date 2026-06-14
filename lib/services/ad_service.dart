import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdService {
  // TEST AdMob IDs (Safe for development)
  // Replace these with your REAL ad unit IDs before publishing the app
  static const String appId = 'ca-app-pub-7540130362404221~9152303573'; // Your real App ID (keep for reference)
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';      // Test Banner
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712'; // Test Interstitial
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';     // Test Rewarded

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool _isPremium = false;
  bool _isLoadingInterstitial = false;
  bool _isLoadingRewarded = false;

  // Call this in initState of screens or in main navigation
  // Now reads directly from the same key used by PurchaseService (single source of truth for real IAP)
  Future<void> loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool('is_premium_unlocked') ?? false;
  }

  bool get isPremium => _isPremium;

  // ===================== BANNER AD =====================
  BannerAd? getBannerAd() {
    if (_isPremium) return null;

    if (_bannerAd == null) {
      _bannerAd = BannerAd(
        adUnitId: bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) => debugPrint('Banner ad loaded'),
          onAdFailedToLoad: (ad, error) {
            debugPrint('Banner ad failed to load: $error');
            ad.dispose();
            _bannerAd = null;
          },
        ),
      );
      _bannerAd!.load();
    }
    return _bannerAd;
  }

  void disposeBanner() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  // ===================== INTERSTITIAL AD =====================
  Future<void> loadInterstitialAd() async {
    if (_isPremium || _isLoadingInterstitial) return;

    _isLoadingInterstitial = true;

    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isLoadingInterstitial = false;
          debugPrint('Interstitial ad loaded');

          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd(); // Preload next one
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Interstitial ad failed to show: $error');
              ad.dispose();
              _interstitialAd = null;
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Interstitial ad failed to load: $error');
          _isLoadingInterstitial = false;
          _interstitialAd = null;
        },
      ),
    );
  }

  Future<void> showInterstitialAd({VoidCallback? onAdClosed}) async {
    if (_isPremium) {
      onAdClosed?.call();
      return;
    }

    if (_interstitialAd != null) {
      await _interstitialAd!.show();
      onAdClosed?.call();
    } else {
      debugPrint('Interstitial ad not ready yet');
      onAdClosed?.call();
      // Try to load for next time
      loadInterstitialAd();
    }
  }

  // ===================== REWARDED AD =====================
  Future<void> loadRewardedAd() async {
    if (_isPremium || _isLoadingRewarded) return;

    _isLoadingRewarded = true;

    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isLoadingRewarded = false;
          debugPrint('Rewarded ad loaded');

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Rewarded ad failed to show: $error');
              ad.dispose();
              _rewardedAd = null;
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Rewarded ad failed to load: $error');
          _isLoadingRewarded = false;
          _rewardedAd = null;
        },
      ),
    );
  }

  Future<void> showRewardedAd({
    required BuildContext context,
    required Function(bool earnedReward) onComplete,
  }) async {
    if (_isPremium) {
      onComplete(true);
      return;
    }

    if (_rewardedAd != null) {
      await _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          debugPrint('User earned reward: ${reward.amount} ${reward.type}');
          onComplete(true);
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rewarded ad not ready. Please try again in a moment.')),
      );
      onComplete(false);
      loadRewardedAd();
    }
  }

  // ===================== UTILITY =====================
  Future<void> refreshPremiumStatus() async {
    await loadPremiumStatus();
  }

  void disposeAll() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _bannerAd = null;
    _interstitialAd = null;
    _rewardedAd = null;
  }
}