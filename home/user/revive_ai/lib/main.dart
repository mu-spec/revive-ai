import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:revive_ai/screens/enhance_screen.dart';
import 'package:revive_ai/screens/history_screen.dart';
import 'package:revive_ai/screens/settings_screen.dart';
import 'package:revive_ai/services/ad_service.dart';
import 'package:revive_ai/services/ai_provider_service.dart';
import 'package:revive_ai/services/connectivity_service.dart';
import 'package:revive_ai/services/history_service.dart';
import 'package:revive_ai/services/purchase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await MobileAds.instance.initialize();
  } catch (_) {}

  final purchaseService = PurchaseService();
  try {
    await purchaseService.initialize();
  } catch (_) {}

  runApp(ReviveAIApp(purchaseService: purchaseService));
}

class ReviveAIApp extends StatelessWidget {
  final PurchaseService purchaseService;

  const ReviveAIApp({super.key, required this.purchaseService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReviveAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      home: MainNavigation(purchaseService: purchaseService),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final PurchaseService purchaseService;
  const MainNavigation({super.key, required this.purchaseService});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final AIProviderService _aiProviderService = AIProviderService();
  final HistoryService _historyService = HistoryService();
  final AdService _adService = AdService();
  final ConnectivityService _connectivityService = ConnectivityService();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _adService.loadPremiumStatus();
    _adService.loadInterstitialAd();
    _adService.loadRewardedAd();

    _screens = [
      EnhanceScreen(
        aiProviderService: _aiProviderService,
        historyService: _historyService,
        adService: _adService,
        purchaseService: widget.purchaseService,
        connectivityService: _connectivityService,
      ),
      HistoryScreen(historyService: _historyService, adService: _adService),
      SettingsScreen(
        aiProviderService: _aiProviderService,
        historyService: _historyService,
        adService: _adService,
        purchaseService: widget.purchaseService,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.auto_fix_high_outlined), selectedIcon: Icon(Icons.auto_fix_high), label: 'Enhance'),
          NavigationDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
