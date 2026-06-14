import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:revive_ai/models/enhancement_mode.dart';
import 'package:revive_ai/models/history_item.dart';
import 'package:revive_ai/screens/result_screen.dart';
import 'package:revive_ai/services/ad_service.dart';
import 'package:revive_ai/services/ai_provider_service.dart';
import 'package:revive_ai/services/connectivity_service.dart';
import 'package:revive_ai/services/history_service.dart';
import 'package:revive_ai/services/purchase_service.dart';
import 'package:revive_ai/widgets/enhancement_card.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as img;

class EnhanceScreen extends StatefulWidget {
  final AIProviderService aiProviderService;
  final HistoryService historyService;
  final AdService adService;
  final PurchaseService purchaseService;
  final ConnectivityService connectivityService;

  const EnhanceScreen({
    super.key,
    required this.aiProviderService,
    required this.historyService,
    required this.adService,
    required this.purchaseService,
    required this.connectivityService,
  });

  @override
  State<EnhanceScreen> createState() => _EnhanceScreenState();
}

class _EnhanceScreenState extends State<EnhanceScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  EnhancementMode? _selectedMode;
  bool _isProcessing = false;
  String _processingStatus = '';
  final Uuid _uuid = const Uuid();
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    widget.adService.refreshPremiumStatus();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connected = await widget.connectivityService.hasConnection();
    if (mounted) setState(() => _isOnline = connected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ReviveAI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Modern Hero header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    const Color(0xFF0D47A1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome, size: 42, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Restore Old Memories',
                    style: TextStyle(
                      fontSize: 26, 
                      fontWeight: FontWeight.w700, 
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Bring blurry, damaged, and black & white photos back to life with powerful AI',
                    style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.35),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Offline warning
            if (!_isOnline)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '⚠ No internet connection. AI enhancement requires internet.',
                  style: TextStyle(color: Colors.red),
                ),
              ),

            // Pick image section - Modern & Clean
            if (_selectedImage == null) ...[
              // Primary action buttons with better visual hierarchy
              FilledButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library_outlined, size: 20),
                label: const Text('Select Photo from Gallery'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(58),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _takePhoto,
                icon: const Icon(Icons.camera_alt_outlined, size: 20),
                label: const Text('Take Photo with Camera'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 32),
              
              // Elegant divider with text
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR CHOOSE ENHANCEMENT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 20),
            ] else ...[
              // Selected photo preview - more modern card treatment
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    _selectedImage!,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedImage = null;
                    _selectedMode = null;
                  });
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Choose a different photo'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 20),

              // Section header
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 12),
                child: Row(
                  children: [
                    Text(
                      'Choose Enhancement',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    if (widget.purchaseService.isPremium)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.workspace_premium, size: 14, color: Colors.amber.shade800),
                            const SizedBox(width: 4),
                            Text(
                              'Premium modes',
                              style: TextStyle(fontSize: 11, color: Colors.amber.shade800, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              ...EnhancementModes.all.map((mode) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.purchaseService.isPremium && mode.benefitsFromPremium)
                          Padding(
                            padding: const EdgeInsets.only(left: 2, bottom: 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.workspace_premium, size: 6, color: Colors.amber.shade200),
                                const SizedBox(width: 1),
                                Text(
                                  'Premium Quality',
                                  style: TextStyle(
                                    fontSize: 6.5,
                                    color: Colors.amber.shade200,
                                    fontWeight: FontWeight.w500,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        EnhancementCard(
                          mode: mode,
                          isSelected: _selectedMode?.type == mode.type,
                          onTap: () => _selectMode(mode),
                        ),
                      ],
                    ),
                  )),

              const SizedBox(height: 16),

              FilledButton.icon(
                onPressed: (_selectedMode != null && !_isProcessing) ? _startEnhancement : null,
                icon: _isProcessing
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.auto_fix_high),
                label: Text(_isProcessing ? 'Enhancing...' : 'Enhance Photo with AI'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  backgroundColor: theme.colorScheme.primary,
                ),
              ),

              if (_isProcessing) ...[
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
                const SizedBox(height: 8),
                Text(_processingStatus, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
              ],

              if (widget.purchaseService.isPremium) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _startBatchEnhancement,
                  icon: const Icon(Icons.collections),
                  label: const Text('Batch Enhance Multiple Photos (Premium)'),
                ),
              ],
            ],

            const SizedBox(height: 24),

            if (!widget.adService.isPremium)
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('Need more enhancements?', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _watchRewardedAdForExtra,
                        icon: const Icon(Icons.play_circle_fill),
                        label: const Text('Watch Ad for 1 Extra Enhancement'),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 32),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tips_and_updates, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        const Text('Pro Tips', style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('• Use high resolution scans for best results'),
                    const Text('• One-Tap works great for most modern photos'),
                    const Text('• Old Photo Restore excels on damaged/faded prints'),
                    const Text('• Colorize is perfect for family history photos'),
                    const Text('• Always compare before/after with the slider!'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _selectedMode = null;
        });
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Future<void> _takePhoto() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      _showError('Camera permission required');
      return;
    }
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 90);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _selectedMode = null;
        });
      }
    } catch (e) {
      _showError('Failed to take photo: $e');
    }
  }

  void _selectMode(EnhancementMode mode) {
    setState(() {
      _selectedMode = mode;
    });
  }

  Future<void> _startEnhancement() async {
    if (_selectedImage == null || _selectedMode == null) return;

    final canEnhance = await widget.historyService.canEnhance();
    if (!canEnhance) {
      _showPaywallDialog();
      return;
    }

    // Real provider token check
    if (widget.aiProviderService.currentProvider == AIProvider.replicate &&
        !widget.aiProviderService.hasReplicateToken) {
      _showError('Please set your Replicate API key in Settings first.\n\nGet a free token at replicate.com');
      return;
    }

    // Real offline check
    final isOnline = await widget.connectivityService.hasConnection();
    if (!isOnline) {
      _showError('No internet connection. Enhancement requires an active internet connection.');
      return;
    }

    setState(() {
      _isProcessing = true;
      _processingStatus = 'Starting...';
    });

    try {
      final enhancedPath = await widget.aiProviderService.enhanceImage(
        imageFile: _selectedImage!,
        mode: _selectedMode!,
        isPremium: widget.purchaseService.isPremium,
        onStatusUpdate: (status) {
          if (mounted) {
            setState(() {
              _processingStatus = status;
            });
          }
        },
      );

      final finalEnhancedPath = await _applyWatermarkIfNeeded(enhancedPath);

      final appDir = await getApplicationDocumentsDirectory();
      final originalCopy = File('${appDir.path}/original_${_uuid.v4()}.jpg');
      await _selectedImage!.copy(originalCopy.path);

      final enhancedCopy = File('${appDir.path}/enhanced_${_uuid.v4()}.png');
      await File(finalEnhancedPath).copy(enhancedCopy.path);

      final historyItem = HistoryItem(
        id: _uuid.v4(),
        originalPath: originalCopy.path,
        enhancedPath: enhancedCopy.path,
        enhancementType: _selectedMode!.type.name,
        enhancementName: _selectedMode!.name,
        timestamp: DateTime.now(),
        isPremium: widget.purchaseService.isPremium,
      );

      await widget.historyService.addHistoryItem(historyItem);
      await widget.historyService.incrementDailyCount();

      if (!mounted) return;

      if (!widget.adService.isPremium) {
        await widget.adService.showInterstitialAd(
          onAdClosed: () => _navigateToResult(originalCopy.path, enhancedCopy.path, historyItem),
        );
      } else {
        _navigateToResult(originalCopy.path, enhancedCopy.path, historyItem);
      }

      setState(() {
        _selectedImage = null;
        _selectedMode = null;
        _isProcessing = false;
        _processingStatus = '';
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _processingStatus = '';
        });
        _showError(e.toString());
      }
    }
  }

  void _navigateToResult(String originalPath, String enhancedPath, HistoryItem historyItem) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          originalPath: originalPath,
          enhancedPath: enhancedPath,
          enhancementName: _selectedMode!.name,
          historyItem: historyItem,
          adService: widget.adService,
          onDelete: () async {
            await widget.historyService.deleteHistoryItem(historyItem.id);
          },
        ),
      ),
    );
  }

  Future<void> _watchRewardedAdForExtra() async {
    await widget.adService.showRewardedAd(
      context: context,
      onComplete: (earned) async {
        if (earned) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thank you! You earned 1 extra free enhancement.'), backgroundColor: Colors.green),
          );
        }
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700, duration: const Duration(seconds: 5)),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How ReviveAI Works'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ReviveAI uses state-of-the-art AI models (Replicate + FAL AI) to restore and enhance your photos.'),
              SizedBox(height: 12),
              Text('• Real AI processing (not demo)', style: TextStyle(fontWeight: FontWeight.w500)),
              Text('• Premium users get higher resolution & better quality'),
              Text('• Strong before/after comparison'),
              SizedBox(height: 12),
              Text('Important:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('You need a Replicate or FAL API key. Your usage is billed by the provider.'),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Got it'))],
      ),
    );
  }

  void _showPaywallDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily Limit Reached'),
        content: const Text(
          'You\'ve used your 5 free enhancements today.\n\n'
          'Go Premium for unlimited enhances, no ads, batch processing, and priority results.\n\n'
          'Tap "Unlock Premium (Buy)" in the Settings tab to purchase via Google Play.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Later')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Go to Settings tab to unlock Premium')),
              );
            },
            child: const Text('Unlock Premium'),
          ),
        ],
      ),
    );
  }

  Future<String> _applyWatermarkIfNeeded(String enhancedPath) async {
    if (widget.adService.isPremium) return enhancedPath;

    try {
      final file = File(enhancedPath);
      final bytes = await file.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return enhancedPath;

      final watermark = 'ReviveAI Free';
      img.drawString(image, watermark, font: img.arial24, x: 20, y: image.height - 35, color: img.ColorRgb8(255, 0, 0));

      final watermarkedBytes = img.encodePng(image);
      final watermarkedFile = File(enhancedPath.replaceAll('.png', '_free.png'));
      await watermarkedFile.writeAsBytes(watermarkedBytes);
      return watermarkedFile.path;
    } catch (e) {
      return enhancedPath;
    }
  }

  Future<void> _startBatchEnhancement() async {
    if (_selectedMode == null) {
      _showError('Please select an enhancement type first');
      return;
    }

    final List<XFile> selected = await _picker.pickMultiImage();
    if (selected.isEmpty) return;

    setState(() {
      _isProcessing = true;
      _processingStatus = 'Starting batch processing...';
    });

    int processed = 0;
    for (final xfile in selected) {
      try {
        setState(() {
          _processingStatus = 'Processing ${processed + 1}/${selected.length}...';
        });

        final imageFile = File(xfile.path);

        final enhancedPath = await widget.aiProviderService.enhanceImage(
          imageFile: imageFile,
          mode: _selectedMode!,
          isPremium: widget.purchaseService.isPremium,
          onStatusUpdate: (status) {
            if (mounted) {
              setState(() {
                _processingStatus = 'Processing ${processed + 1}/${selected.length}: $status';
              });
            }
          },
        );

        final finalPath = await _applyWatermarkIfNeeded(enhancedPath);

        final appDir = await getApplicationDocumentsDirectory();
        final originalCopy = File('${appDir.path}/batch_original_${_uuid.v4()}.jpg');
        await imageFile.copy(originalCopy.path);

        final enhancedCopy = File('${appDir.path}/batch_enhanced_${_uuid.v4()}.png');
        await File(finalPath).copy(enhancedCopy.path);

        final historyItem = HistoryItem(
          id: _uuid.v4(),
          originalPath: originalCopy.path,
          enhancedPath: enhancedCopy.path,
          enhancementType: _selectedMode!.type.name,
          enhancementName: _selectedMode!.name,
          timestamp: DateTime.now(),
          isPremium: widget.purchaseService.isPremium,
        );

        await widget.historyService.addHistoryItem(historyItem);
        processed++;
      } catch (e) {
        _showError('Error in batch item ${processed + 1}: $e');
      }
    }

    setState(() {
      _isProcessing = false;
      _processingStatus = '';
      _selectedImage = null;
      _selectedMode = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Batch complete: $processed items processed')),
    );
  }
}
