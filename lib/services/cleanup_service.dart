import '../core/device_channel.dart';
import '../core/models/app_info.dart';
import '../core/models/cleanup_result.dart';

class CleanupService {
  final DeviceChannel _channel;

  CleanupService(this._channel);

  Future<List<AppInfo>> getApps() async {
    final raw = await _channel.getAppList();
    return raw
        .map((e) => AppInfo.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<CleanupResult> clean(List<String> packages) async {
    final data = await _channel.cleanCache(packages);
    return CleanupResult.fromJson(data);
  }

  Future<void> openAppSettings(String package) =>
      _channel.openAppSettings(package);
}
