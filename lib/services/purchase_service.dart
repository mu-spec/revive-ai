import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseService {
  static const String _premiumKey = 'is_premium_unlocked';
  static const String _premiumProductId = 'premium_unlock'; // Change this to your actual product ID in Play Console

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool _isPremium = false;
  bool get isPremium => _isPremium;

  final _premiumStatusController = StreamController<bool>.broadcast();
  Stream<bool> get premiumStatusStream => _premiumStatusController.stream;

  Future<void> initialize() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      print('In-app purchases not available');
      await _loadLocalPremiumStatus();
      return;
    }

    // Load previous purchase status
    await _loadLocalPremiumStatus();

    // Listen to purchase updates
    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (error) => print('Purchase stream error: $error'),
    );

    // Restore previous purchases on init
    await restorePurchases();
  }

  Future<void> _loadLocalPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool(_premiumKey) ?? false;
    _premiumStatusController.add(_isPremium);
  }

  Future<void> _savePremiumStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, value);
    _isPremium = value;
    _premiumStatusController.add(value);
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        if (purchaseDetails.productID == _premiumProductId) {
          _savePremiumStatus(true);
        }
      }

      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> buyPremium() async {
    final ProductDetailsResponse productDetailsResponse =
        await _inAppPurchase.queryProductDetails({_premiumProductId});

    if (productDetailsResponse.productDetails.isEmpty) {
      print('Product not found. Make sure the product ID "premium_unlock" is created and active in Google Play Console.');
      // Note: Without a Play Console account + product setup, purchases cannot complete.
      // See NEXT_STEPS.md or ask for setup instructions.
      return;
    }

    final ProductDetails productDetails = productDetailsResponse.productDetails.first;

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  void dispose() {
    _subscription.cancel();
    _premiumStatusController.close();
  }
}
