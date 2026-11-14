import 'dart:convert';

import 'package:flutter/services.dart';

class DeviceChannel {
  static const MethodChannel _channel = MethodChannel('driva/device');

  Future<dynamic> _invoke(String method, [Object? arguments]) async {
    try {
      final raw = await _channel.invokeMethod<dynamic>(method, arguments);
      if (raw is String) {
        return jsonDecode(raw);
      }
      return raw;
    } on PlatformException catch (e) {
      throw DeviceChannelException(e.message ?? 'Unknown native error');
    } on MissingPluginException {
      throw DeviceChannelException(
          'Canal nativo no disponible (ejecutar en Android con implementación Kotlin)');
    }
  }

  Future<Map<String, dynamic>> getBatteryHealth() =>
      _unwrap('getBatteryHealth');

  Future<Map<String, dynamic>> getStorageStats() => _unwrap('getStorageStats');

  Future<List<dynamic>> getAppList() async =>
      (await _unwrap('getAppList'))['apps'] as List<dynamic>? ?? [];

  Future<Map<String, dynamic>> cleanCache(List<String> packages) =>
      _unwrap('cleanCache', {'packages': packages});

  Future<void> openAppSettings(String package) =>
      _unwrap('openAppSettings', {'package': package});

  Future<Map<String, dynamic>> _unwrap(String method, [Object? args]) async {
    final raw = await _invoke(method, args);
    final result = Map<String, dynamic>.from(raw as Map);
    if (result['ok'] == true) {
      return Map<String, dynamic>.from(result['data'] as Map? ?? {});
    }
    throw DeviceChannelException(
        (result['error'] as String?) ?? 'Error desconocido');
  }
}

class DeviceChannelException implements Exception {
  final String message;
  DeviceChannelException(this.message);

  @override
  String toString() => message;
}
