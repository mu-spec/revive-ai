import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:revive_ai/services/ad_service.dart';
import 'package:revive_ai/services/ai_provider_service.dart';
import 'package:revive_ai/services/history_service.dart';
import 'package:revive_ai/services/purchase_service.dart';

class SettingsScreen extends StatefulWidget {
  final AIProviderService aiProviderService;
  final HistoryService historyService;
  final AdService adService;
  final PurchaseService purchaseService;

  const SettingsScreen({
    super.key,
    required this.aiProviderService,
    required this.historyService,
    required this.adService,
    required this.purchaseService,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _falKeyController = TextEditingController();
  final TextEditingController _proxyController = TextEditingController();

  bool _isPremium = false;
  int _dailyCount = 0;
  bool _isLoading = true;

  AIProvider _selectedProvider = AIProvider.fal; // FAL is the main/recommended provider now

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();

    // Replicate
    final savedKey = prefs.getString('replicate_api_key') ?? '';
    _apiKeyController.text = savedKey;
    if (savedKey.isNotEmpty) {
      widget.aiProviderService.setReplicateToken(savedKey);
    }

    // FAL
    final savedFal = prefs.getString('fal_api_key') ?? '';
    _falKeyController.text = savedFal;
    if (savedFal.isNotEmpty) {
      widget.aiProviderService.setFalApiKey(savedFal);
    }

    // Proxy
    final savedProxy = prefs.getString('proxy_url') ?? '';
    _proxyController.text = savedProxy;
    if (savedProxy.isNotEmpty) {
      widget.aiProviderService.setProxyUrl(savedProxy);
    }

    _selectedProvider = widget.aiProviderService.currentProvider;

    _isPremium = widget.purchaseService.isPremium;
    _dailyCount = await widget.historyService.getDailyCount();
    await widget.adService.refreshPremiumStatus();

    setState(() => _isLoading = false);
  }

  Future<void> _saveReplicateKey() async {
    final key = _apiKeyController.text.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('replicate_api_key', key);
    widget.aiProviderService.setReplicateToken(key);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Replicate API key saved!')),
      );
    }
  }

  Future<void> _saveFalKey() async {
    final key = _falKeyController.text.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fal_api_key', key);
    widget.aiProviderService.setFalApiKey(key);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('FAL API key saved!')),
      );
    }
  }

  Future<void> _saveProxy() async {
    final url = _proxyController.text.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('proxy_url', url);
    widget.aiProviderService.setProxyUrl(url.isEmpty ? null : url);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(url.isEmpty ? 'Proxy disabled' : 'Proxy URL saved')),
      );
    }
  }

  Future<void> _changeProvider(AIProvider provider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ai_provider', provider.name);

    setState(() {
      _selectedProvider = provider;
    });
    widget.aiProviderService.setProvider(provider);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Switched to ${provider.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          // AI Provider Section - Modern & Clear
          _buildSectionHeader('AI Provider'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 22),
                      const SizedBox(width: 10),
                      const Text('Choose AI Engine', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'FAL is the fastest and simplest option for most users.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<AIProvider>(
                    value: _selectedProvider,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    items: AIProvider.values.map((p) {
                      final isRecommended = p == AIProvider.fal;
                      return DropdownMenuItem(
                        value: p,
                        child: Row(
                          children: [
                            Text(p.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w500)),
                            if (isRecommended) ...[
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'RECOMMENDED',
                                  style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) _changeProvider(val);
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _selectedProvider == AIProvider.fal
                        ? 'Using FAL AI — enter your key below'
                        : 'Using Replicate — see Advanced section',
                    style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // FAL API Key - Primary Card
          _buildSectionHeader('API Configuration'),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flash_on, color: Colors.amber.shade700, size: 22),
                      const SizedBox(width: 10),
                      const Text('FAL AI API Key', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Required for the recommended provider. Get one free at fal.ai',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _falKeyController,
                    decoration: InputDecoration(
                      labelText: 'FAL API Key',
                      hintText: 'f3328d24-...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.key),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _saveFalKey,
                      icon: const Icon(Icons.save_alt),
                      label: const Text('Save FAL Key'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Advanced Section - Clean Expansion
          ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            childrenPadding: const EdgeInsets.only(top: 4),
            title: const Row(
              children: [
                Icon(Icons.tune, size: 20, color: Colors.grey),
                SizedBox(width: 10),
                Text('Advanced Options', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
            subtitle: const Text('Replicate fallback & backend proxy', style: TextStyle(fontSize: 12)),
            children: [
              Card(
                margin: const EdgeInsets.only(top: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Replicate
                      TextField(
                        controller: _apiKeyController,
                        decoration: InputDecoration(
                          labelText: 'Replicate API Key (Fallback)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          isDense: true,
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton(
                          onPressed: _saveReplicateKey,
                          child: const Text('Save Replicate Key'),
                        ),
                      ),
                      const Divider(height: 28),
                      // Proxy
                      TextField(
                        controller: _proxyController,
                        decoration: InputDecoration(
                          labelText: 'Backend Proxy URL',
                          hintText: 'https://...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton(
                          onPressed: _saveProxy,
                          child: const Text('Save Proxy'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Usage Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.today_outlined, size: 20),
                      SizedBox(width: 10),
                      Text('Usage Today', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Free enhancements used'),
                      Text(
                        '$_dailyCount / 5',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Premium = unlimited + HD quality + no ads + batch',
                    style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Legal Links - Clean
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.open_in_new, size: 20),
                  onTap: () => launchUrl(Uri.parse('https://idyllic-pothos-cce5d7.netlify.app')),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.open_in_new, size: 20),
                  onTap: () => launchUrl(Uri.parse('https://golden-trifle-504c14.netlify.app')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _falKeyController.dispose();
    _proxyController.dispose();
    super.dispose();
  }

  // Modern section header helper
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.grey,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
