import 'package:flutter/material.dart';

enum EnhancementType {
  oneTap,
  oldPhotoRestore,
  faceEnhance,
  colorize,
  unblurUpscale,
  backgroundCleanup,
  cartoonAnime,
  portraitStudio,
}

class EnhancementMode {
  final EnhancementType type;
  final String name;
  final String description;
  final IconData icon;
  final String model;
  final Map<String, dynamic> defaultParams;
  final String inputKey;
  final String endpoint;

  const EnhancementMode({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.model,
    required this.defaultParams,
    required this.inputKey,
    required this.endpoint,
  });

  bool get usesModelEndpoint => endpoint.startsWith('models/');

  /// Whether this mode gets a real quality boost when the user is Premium.
  /// Used to show the "Premium Quality" indicator only on modes that actually benefit.
  bool get benefitsFromPremium {
    switch (type) {
      case EnhancementType.faceEnhance:
      case EnhancementType.portraitStudio:
      case EnhancementType.unblurUpscale:
      case EnhancementType.cartoonAnime:
      case EnhancementType.oldPhotoRestore:
      case EnhancementType.oneTap:
        return true;
      case EnhancementType.colorize:
      case EnhancementType.backgroundCleanup:
        return false;
    }
  }
}

class EnhancementModes {
  static const List<EnhancementMode> all = [
    EnhancementMode(
      type: EnhancementType.oneTap,
      name: 'One-Tap Auto Enhance',
      description: 'Instantly improve quality, sharpen details and upscale to HD. Perfect for most photos.',
      icon: Icons.auto_fix_high,
      model: 'flux-kontext-apps/restore-image',
      defaultParams: {
        'output_format': 'png',
        'safety_tolerance': 2,
      },
      inputKey: 'input_image',
      endpoint: 'models/flux-kontext-apps/restore-image',
    ),
    EnhancementMode(
      type: EnhancementType.oldPhotoRestore,
      name: 'Old Photo Restore',
      description: 'Remove scratches, restore faded colors, fix damaged images. Bring old memories back to life.',
      icon: Icons.history,
      model: 'flux-kontext-apps/restore-image',
      defaultParams: {
        'output_format': 'png',
        'safety_tolerance': 2,
      },
      inputKey: 'input_image',
      endpoint: 'models/flux-kontext-apps/restore-image',
    ),
    EnhancementMode(
      type: EnhancementType.faceEnhance,
      name: 'Face Enhance',
      description: 'Improve eyes, skin, details. Fix blurry faces. Great for portraits and group photos.',
      icon: Icons.face,
      model: 'sczhou/codeformer:cc4956dd26fa5a7185d5660cc9100fab1b8070a1d1654a8bb5eb6d443b020bb2',
      defaultParams: {
        'codeformer_fidelity': 0.5,
        'background_enhance': true,
        'face_upsample': true,
        'upscale': 2,
      },
      inputKey: 'image',
      endpoint: 'predictions',
    ),
    EnhancementMode(
      type: EnhancementType.portraitStudio,
      name: 'Portrait Studio',
      description: 'Professional studio-quality portrait enhancement. Natural skin tones, sharp eyes, beautiful lighting and subtle bokeh.',
      icon: Icons.person,
      model: 'sczhou/codeformer:cc4956dd26fa5a7185d5660cc9100fab1b8070a1d1654a8bb5eb6d443b020bb2',
      defaultParams: {
        'codeformer_fidelity': 0.65,
        'background_enhance': true,
        'face_upsample': true,
        'upscale': 2,
      },
      inputKey: 'image',
      endpoint: 'predictions',
    ),
    EnhancementMode(
      type: EnhancementType.colorize,
      name: 'Colorize B&W Photo',
      description: 'Add natural, realistic colors to black & white photos. Very viral and emotional.',
      icon: Icons.palette,
      model: 'piddnad/ddcolor:ca494ba129e44e45f661d6ece83c4c98a9a7c774309beca01429b58fce8aa695',
      defaultParams: {
        'model_size': 'large',
      },
      inputKey: 'image',
      endpoint: 'predictions',
    ),
    EnhancementMode(
      type: EnhancementType.unblurUpscale,
      name: 'Unblur & Upscale HD',
      description: 'Remove grain, motion blur and upscale to high resolution. Perfect for low quality scans.',
      icon: Icons.high_quality,
      model: 'sczhou/codeformer:cc4956dd26fa5a7185d5660cc9100fab1b8070a1d1654a8bb5eb6d443b020bb2',
      defaultParams: {
        'codeformer_fidelity': 0.3,
        'background_enhance': true,
        'face_upsample': true,
        'upscale': 4,
      },
      inputKey: 'image',
      endpoint: 'predictions',
    ),
    EnhancementMode(
      type: EnhancementType.cartoonAnime,
      name: 'Cartoon & Anime',
      description: 'Transform photos into vibrant cartoon or anime style with clean lines, bold colors, and artistic look.',
      icon: Icons.brush,
      model: 'sczhou/codeformer:cc4956dd26fa5a7185d5660cc9100fab1b8070a1d1654a8bb5eb6d443b020bb2',
      defaultParams: {
        'codeformer_fidelity': 0.2,
        'background_enhance': false,
        'face_upsample': true,
        'upscale': 2,
      },
      inputKey: 'image',
      endpoint: 'predictions',
    ),
    EnhancementMode(
      type: EnhancementType.backgroundCleanup,
      name: 'Background Cleanup',
      description: 'Remove unwanted objects and clean up backgrounds for a polished look.',
      icon: Icons.cleaning_services,
      model: 'clipdrop/remove-background',
      defaultParams: {},
      inputKey: 'image',
      endpoint: 'models/clipdrop/remove-background',
    ),
  ];

  static EnhancementMode getByType(EnhancementType type) {
    return all.firstWhere((m) => m.type == type);
  }
}
