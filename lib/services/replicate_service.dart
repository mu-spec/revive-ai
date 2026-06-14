import 'package:image/image.dart' as img;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:revive_ai/models/enhancement_mode.dart';

class ReplicateService {
  String? _apiToken;
  String? _proxyUrl;

  void setApiToken(String token) => _apiToken = token.trim();
  void setProxyUrl(String? url) => _proxyUrl = url?.trim();

  bool get hasToken => _apiToken != null && _apiToken!.isNotEmpty;
  bool get usingProxy => _proxyUrl != null && _proxyUrl!.isNotEmpty;

  Future<String> enhanceImage({
    required File imageFile,
    required EnhancementMode mode,
    bool isPremium = false,
    Function(String status)? onStatusUpdate,
  }) async {
    onStatusUpdate?.call('Preparing image...');

    // Real low-RAM optimization
    final compressed = await _compressForLowRam(imageFile, maxWidth: isPremium ? 1536 : 1024);
    final base64Image = base64Encode(compressed);
    final dataUri = 'data:image/jpeg;base64,$base64Image';

    final input = {
      mode.inputKey: dataUri,
      ...mode.defaultParams,
    };

    // Real Premium quality boost
    if (isPremium) {
      if ([EnhancementType.faceEnhance, EnhancementType.portraitStudio].contains(mode.type)) {
        input['codeformer_fidelity'] = 0.75;
        input['upscale'] = 4;
      } else if (mode.type == EnhancementType.unblurUpscale) {
        input['upscale'] = 4;
      } else if (mode.type == EnhancementType.cartoonAnime) {
        input['codeformer_fidelity'] = 0.15;
        input['upscale'] = 3;
      }
    }

    if (usingProxy) {
      return await _callViaProxy(proxyUrl: _proxyUrl!, input: input, mode: mode, onStatusUpdate: onStatusUpdate);
    }

    return await _callReplicateDirect(input: input, mode: mode, onStatusUpdate: onStatusUpdate);
  }

  Future<String> _callReplicateDirect({
    required Map<String, dynamic> input,
    required EnhancementMode mode,
    Function(String)? onStatusUpdate,
  }) async {
    if (!hasToken) throw Exception('No Replicate token set');

    onStatusUpdate?.call('Uploading to Replicate...');

    final url = mode.usesModelEndpoint
        ? 'https://api.replicate.com/v1/models/${mode.model}/predictions'
        : 'https://api.replicate.com/v1/predictions';

    final body = mode.usesModelEndpoint
        ? {'input': input}
        : {'version': mode.model, 'input': input};

    final res = await http.post(
      Uri.parse(url),
      headers: {'Authorization': 'Token $_apiToken', 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Replicate error: ${res.body}');
    }

    final prediction = jsonDecode(res.body);
    return await _pollReplicate(prediction['id'], onStatusUpdate);
  }

  Future<String> _callViaProxy({
    required String proxyUrl,
    required Map<String, dynamic> input,
    required EnhancementMode mode,
    Function(String)? onStatusUpdate,
  }) async {
    onStatusUpdate?.call('Connecting to secure backend...');

    final res = await http.post(
      Uri.parse(proxyUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'mode': mode.type.name,
        'model': mode.model,
        'input': input,
      }),
    );

    if (res.statusCode != 200) throw Exception('Proxy error: ${res.body}');

    final data = jsonDecode(res.body);
    final imageUrl = data['output_url'] as String;

    onStatusUpdate?.call('Downloading from backend...');
    final imgRes = await http.get(Uri.parse(imageUrl));
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/proxy_${DateTime.now().millisecondsSinceEpoch}.png';
    await File(path).writeAsBytes(imgRes.bodyBytes);
    return path;
  }

  Future<String> _pollReplicate(String id, Function(String)? onStatusUpdate) async {
    onStatusUpdate?.call('AI is working...');
    for (int i = 0; i < 60; i++) {
      await Future.delayed(const Duration(seconds: 3));
      final res = await http.get(
        Uri.parse('https://api.replicate.com/v1/predictions/$id'),
        headers: {'Authorization': 'Token $_apiToken'},
      );
      if (res.statusCode != 200) continue;
      final data = jsonDecode(res.body);
      if (data['status'] == 'succeeded') {
        onStatusUpdate?.call('Downloading...');
        final url = (data['output'] as List).first.toString();
        final img = await http.get(Uri.parse(url));
        final temp = await getTemporaryDirectory();
        final path = '${temp.path}/revive_${DateTime.now().millisecondsSinceEpoch}.png';
        await File(path).writeAsBytes(img.bodyBytes);
        return path;
      }
      if (data['status'] == 'failed') throw Exception(data['error']);
    }
    throw Exception('Timeout');
  }

  // Real low-RAM optimization (aggressive compression)
  Future<List<int>> _compressForLowRam(File file, {int maxWidth = 1024}) async {
    final bytes = await file.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return bytes;
    img.Image resized = decoded;
    if (decoded.width > maxWidth) {
      resized = img.copyResize(decoded, width: maxWidth);
    }
    return img.encodeJpg(resized, quality: 82);
  }
}
