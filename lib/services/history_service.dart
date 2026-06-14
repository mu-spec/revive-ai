import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:revive_ai/models/history_item.dart';

class HistoryService {
  static const String _historyKey = 'history_items';
  static const String _dailyCountKey = 'daily_enhance_count';
  static const String _lastResetKey = 'last_daily_reset';

  List<HistoryItem> _cachedHistory = [];
  bool _isLoaded = false;

  /// Returns true if user is Premium (synchronized with PurchaseService via shared prefs)
  Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_premium_unlocked') ?? false;
  }

  /// Check if user can perform another enhancement today
  /// Premium users: always true
  /// Free users: true if < 5 enhancements today
  Future<bool> canEnhance() async {
    if (await isPremium()) return true;

    final count = await getDailyCount();
    return count < 5;
  }

  /// Get current daily count (resets automatically if new day)
  Future<int> getDailyCount() async {
    final prefs = await SharedPreferences.getInstance();
    await _checkAndResetDaily(prefs);
    return prefs.getInt(_dailyCountKey) ?? 0;
  }

  /// Increment daily count (only for free users; premium skips)
  Future<void> incrementDailyCount() async {
    if (await isPremium()) return;

    final prefs = await SharedPreferences.getInstance();
    await _checkAndResetDaily(prefs);

    int count = prefs.getInt(_dailyCountKey) ?? 0;
    count++;
    await prefs.setInt(_dailyCountKey, count);
  }

  /// Legacy method kept for backward compatibility during transition to real IAP.
  /// Does nothing now — premium is controlled exclusively by real purchases.
  Future<void> setPremium(bool value) async {
    // No-op: Premium status now comes only from PurchaseService / Google Play
    // The 'is_premium_unlocked' key is managed by PurchaseService.
  }

  /// Add a new history item (persisted locally)
  Future<void> addHistoryItem(HistoryItem item) async {
    await _loadHistoryIfNeeded();
    _cachedHistory.insert(0, item); // newest first
    await _saveHistory();
  }

  /// Delete item by id
  Future<void> deleteHistoryItem(String id) async {
    await _loadHistoryIfNeeded();
    _cachedHistory.removeWhere((item) => item.id == id);
    await _saveHistory();
  }

  /// Get all history items (newest first)
  Future<List<HistoryItem>> getHistoryItems() async {
    await _loadHistoryIfNeeded();
    return List.unmodifiable(_cachedHistory);
  }

  /// Clear all history (for testing/debug)
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    _cachedHistory.clear();
    _isLoaded = true;
  }

  // ==================== PRIVATE HELPERS ====================

  Future<void> _loadHistoryIfNeeded() async {
    if (_isLoaded) return;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_historyKey) ?? '';
    _cachedHistory = HistoryItem.listFromJsonString(jsonString);
    _isLoaded = true;
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = HistoryItem.listToJsonString(_cachedHistory);
    await prefs.setString(_historyKey, jsonString);
  }

  Future<void> _checkAndResetDaily(SharedPreferences prefs) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastReset = prefs.getString(_lastResetKey);

    if (lastReset != today) {
      await prefs.setInt(_dailyCountKey, 0);
      await prefs.setString(_lastResetKey, today);
    }
  }
}
