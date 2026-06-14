import 'dart:io';
import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:revive_ai/models/history_item.dart';
import 'package:revive_ai/services/ad_service.dart';

class ResultScreen extends StatefulWidget {
  final String originalPath;
  final String enhancedPath;
  final String enhancementName;
  final HistoryItem historyItem;
  final AdService adService;
  final Future<void> Function()? onDelete;

  const ResultScreen({
    super.key,
    required this.originalPath,
    required this.enhancedPath,
    required this.enhancementName,
    required this.historyItem,
    required this.adService,
    this.onDelete,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  double _sliderValue = 0.5;
  BannerAd? _bannerAd;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    widget.adService.refreshPremiumStatus();
    if (!widget.adService.isPremium) {
      _bannerAd = widget.adService.getBannerAd();
    }
  }

  @override
  void dispose() {
    // Banner is managed by AdService, don't dispose here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showAds = !widget.adService.isPremium;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.enhancementName),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareResult,
            tooltip: 'Share',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteResult,
            tooltip: 'Delete from history',
          ),
        ],
      ),
      body: Column(
        children: [
          // Elegant Before / After header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLabel('BEFORE', Colors.red.shade400),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: const Icon(Icons.compare_arrows, size: 18, color: Colors.grey),
                ),
                _buildLabel('AFTER', theme.colorScheme.primary),
              ],
            ),
          ),

          // Premium badge - more refined
          if (widget.historyItem.isPremium)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium, size: 15, color: Colors.amber.shade700),
                    const SizedBox(width: 6),
                    Text(
                      'Premium Quality Result',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Before After Slider - better padding and rounded treatment
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BeforeAfter(
                    value: _sliderValue,
                    onValueChanged: (value) => setState(() => _sliderValue = value),
                    before: Image.file(
                      File(widget.originalPath),
                      fit: BoxFit.contain,
                    ),
                    after: Image.file(
                      File(widget.enhancedPath),
                      fit: BoxFit.contain,
                    ),
                    thumbColor: theme.colorScheme.primary,
                    thumbHeight: 36,
                    thumbWidth: 5,
                  ),
                ),
              ),
            ),
          ),

          // Banner Ad for Free Users
          if (showAds && _bannerAd != null)
            Container(
              height: 50,
              alignment: Alignment.center,
              color: Colors.grey.shade50,
              child: AdWidget(ad: _bannerAd!),
            ),

          // Modern Action Buttons Section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade100, width: 1)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isSaving ? null : _saveToGallery,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(
                                widget.historyItem.isPremium
                                    ? Icons.workspace_premium
                                    : Icons.download_outlined,
                                size: 20,
                              ),
                        label: Text(
                          widget.historyItem.isPremium
                              ? 'Save Premium Quality'
                              : 'Save to Gallery',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _shareResult,
                        icon: const Icon(Icons.share, size: 20),
                        label: const Text(
                          'Share Result',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Drag the slider to compare • AI-enhanced result',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Future<void> _shareResult() async {
    try {
      await Share.shareXFiles(
        [XFile(widget.enhancedPath)],
        text: 'Check out this photo I restored with ReviveAI! ✨\n\n#ReviveAI #PhotoRestore',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Share failed: $e')),
        );
      }
    }
  }

  Future<void> _saveToGallery() async {
    setState(() => _isSaving = true);

    try {
      // Request proper media permission
      PermissionStatus status = await Permission.photos.request();

      // For older Android versions (below 13), also try storage permission
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }

      if (status.isGranted) {
        await Gal.putImage(widget.enhancedPath);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Saved to Gallery successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else if (status.isPermanentlyDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Permission permanently denied. Please enable it from settings.'),
              action: SnackBarAction(
                label: 'Open Settings',
                onPressed: openAppSettings,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permission denied. Cannot save to gallery.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _deleteResult() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this result?'),
        content: const Text('This will remove it from your history permanently.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && widget.onDelete != null) {
      await widget.onDelete!();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Result deleted from history')),
        );
      }
    }
  }
}