import 'dart:convert';

class HistoryItem {
  final String id;
  final String originalPath;
  final String enhancedPath;
  final String enhancementType;
  final String enhancementName;
  final DateTime timestamp;
  final bool isPremium; // Whether this enhancement was performed under Premium (for UI badges)

  const HistoryItem({
    required this.id,
    required this.originalPath,
    required this.enhancedPath,
    required this.enhancementType,
    required this.enhancementName,
    required this.timestamp,
    this.isPremium = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'originalPath': originalPath,
        'enhancedPath': enhancedPath,
        'enhancementType': enhancementType,
        'enhancementName': enhancementName,
        'timestamp': timestamp.toIso8601String(),
        'isPremium': isPremium,
      };

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
        id: json['id'] as String,
        originalPath: json['originalPath'] as String,
        enhancedPath: json['enhancedPath'] as String,
        enhancementType: json['enhancementType'] as String,
        enhancementName: json['enhancementName'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        isPremium: json['isPremium'] as bool? ?? false,
      );

  static List<HistoryItem> listFromJsonString(String jsonString) {
    if (jsonString.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonString);
      return list.map((e) => HistoryItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  static String listToJsonString(List<HistoryItem> items) {
    return jsonEncode(items.map((e) => e.toJson()).toList());
  }
}
