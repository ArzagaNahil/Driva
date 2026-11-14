import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/models/cleanup_record.dart';

class HistoryRepository {
  static const _key = 'cleanup_history';

  Future<List<CleanupRecord>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => CleanupRecord.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
      list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return list;
    } catch (_) {
      return [];
    }
  }

  Future<void> add(CleanupRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await load();
    current.add(record);
    current.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    if (current.length > 100) {
      current.removeRange(100, current.length);
    }
    await prefs.setString(
      _key,
      jsonEncode(current.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
