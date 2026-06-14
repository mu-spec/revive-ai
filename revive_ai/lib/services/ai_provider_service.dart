import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:revive_ai/models/enhancement_mode.dart';
import 'package:revive_ai/services/replicate_service.dart';

enum AIProvider {
  replicate,
  fal,
}

class AIProviderService {
  final ReplicateService _replicate = ReplicateService();

  AIProvider _currentProvider = AIProvider.fal; // FAL is now the default (real working provider, no backend needed)
  String? _falApiKey;
  String? _proxyUrl;

  AIProvider get currentProvider => _currentProvider;

  void setProvider(AIProvider provider) {
    _currentProvider = provider;
  }

  void setReplicateToken(String token) {
    _replicate.setApiToken(token);
  }

  void setFalApiKey(String key) {
    _falApiKey = key.trim();
  }

  void setProxyUrl(String? url) {
    _proxyUrl = url?.trim();
    _replicate.setProxyUrl(_proxyUrl);
  }

  bool get hasReplicateToken => _replicate.hasToken;
  bool get usingProxy => _replicate.usingProxy;

  /// Main entry point for enhancement.
  /// Supports Replicate (with optional proxy) and real FAL AI.
  Future<String> enhanceImage({
    required File imageFile,
    required EnhancementMode mode,
    bool isPremium = false,
    Function(String status)? onStatusUpdate,
  }) async {
    if (_currentProvider == AIProvider.fal) {
      return await _enhanceWithFal(
        imageFile: imageFile,
        mode: mode,
        isPremium: isPremium,
        onStatusUpdate: onStatusUpdate,
      );
    } else {
      return await _replicate.enhanceImage(
        imageFile: imageFile,
        mode: mode,
        isPremium: isPremium,
        onStatusUpdate: onStatusUpdate,
      );
    }
  }

  // ==================== REAL FAL AI INTEGRATION ====================
  Future<String> _enhanceWithFal({
    required File imageFile,
    required EnhancementMode mode,
    bool isPremium = false,
    Function(String)? onStatusUpdate,
  }) async {
    if (_falApiKey == null || _falApiKey!.isEmpty) {
      throw Exception('FAL API key is not set. Please add it in Settings.');
    }

    onStatusUpdate?.call('Uploading to FAL AI...');

    final bytes = await imageFile.readAsBytes();
    final base64 = base64Encode(bytes);
    final dataUri = 'data:image/jpeg;base64,$base64';

    // Real FAL AI call (using their image-to-image endpoint)
    final response = await http.post(
      Uri.parse('https://fal.run/fal-ai/image-to-image'),
      headers: {
        'Authorization': 'Key $_falApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'image_url': dataUri,
        'prompt': 'high quality, detailed, natural photo restoration and enhancement',
        'strength': isPremium ? 0.72 : 0.55,
        'guidance_scale': 7.5,
        'num_inference_steps': isPremium ? 30 : 20,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('FAL AI error: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final imageUrl = data['image']['url'] as String;

    onStatusUpdate?.call('Downloading from FAL AI...');

    final download = await http.get(Uri.parse(imageUrl));
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/fal_${DateTime.now().millisecondsSinceEpoch}.png';
    await File(path).writeAsBytes(download.bodyBytes);

    return path;
  }
}
