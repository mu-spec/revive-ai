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
  
  // Initialize Google Mobile Ads
  await MobileAds.instance.initialize();

  // Initialize Purchase Service (for real Premium)
  final purchaseService = PurchaseService();
  await purchaseService.initialize();
  
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0), // Professional deep blue
          brightness: Brightness.light,
          surface: const Color(0xFFFAFBFC),
          surfaceContainerHighest: const Color(0xFFF1F3F5),
        ),
        useMaterial3: true,
        
        // Modern professional typography
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.3),
          titleLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.2),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 15, height: 1.4),
          bodyMedium: TextStyle(fontSize: 14, height: 1.35),
        ),
        
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1A1A2E),
          titleTextStyle: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
          ),
        ),
        
        cardTheme: const CardTheme(
          elevation: 1.5,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
          margin: EdgeInsets.zero,
        ),
        
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            elevation: 0,
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            side: const BorderSide(width: 1.2),
          ),
        ),
        
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF1565C0).withValues(alpha: 0.12),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ),
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
      HistoryScreen(
        historyService: _historyService,
        adService: _adService,
      ),
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
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.auto_fix_high_outlined),
            selectedIcon: Icon(Icons.auto_fix_high),
            label: 'Enhance',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
