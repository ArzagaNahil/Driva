import '../core/device_channel.dart';
import '../core/models/battery_health.dart';
import '../core/models/storage_stats.dart';

class DeviceHealthService {
  final DeviceChannel _channel;

  DeviceHealthService(this._channel);

  Future<BatteryHealth> getBattery() async {
    final data = await _channel.getBatteryHealth();
    return BatteryHealth.fromJson(data);
  }

  Future<StorageStats> getStorage() async {
    final data = await _channel.getStorageStats();
    return StorageStats.fromJson(data);
  }
}
