import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FavoritesRepository {
  static const _key = 'favorite_packages';

  Future<Set<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return <String>{};
    try {
      final list = (jsonDecode(raw) as List<dynamic>)
          .whereType<String>()
          .toSet();
      return list;
    } catch (_) {
      return <String>{};
    }
  }

  Future<void> setFavorites(Set<String> packages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(packages.toList()));
  }
}
