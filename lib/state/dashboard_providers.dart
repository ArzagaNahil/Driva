import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/device_channel.dart';
import '../core/models/app_info.dart';
import '../core/models/battery_health.dart';
import '../core/models/cleanup_record.dart';
import '../core/models/storage_stats.dart';
import '../services/cleanup_service.dart';
import '../services/device_health_service.dart';
import '../services/favorites_repository.dart';
import '../services/history_repository.dart';

final deviceChannelProvider = Provider<DeviceChannel>((ref) => DeviceChannel());

final deviceHealthServiceProvider =
    Provider<DeviceHealthService>((ref) => DeviceHealthService(ref.watch(deviceChannelProvider)));

final cleanupServiceProvider =
    Provider<CleanupService>((ref) => CleanupService(ref.watch(deviceChannelProvider)));

final historyRepositoryProvider =
    Provider<HistoryRepository>((ref) => HistoryRepository());

final favoritesRepositoryProvider =
    Provider<FavoritesRepository>((ref) => FavoritesRepository());

final batteryProvider = FutureProvider<BatteryHealth>(
  (ref) => ref.watch(deviceHealthServiceProvider).getBattery(),
);

final storageProvider = FutureProvider<StorageStats>(
  (ref) => ref.watch(deviceHealthServiceProvider).getStorage(),
);

final appsProvider = FutureProvider<List<AppInfo>>(
  (ref) => ref.watch(cleanupServiceProvider).getApps(),
);

class HistoryState {
  final List<CleanupRecord> records;
  const HistoryState({this.records = const []});

  HistoryState copyWith({List<CleanupRecord>? records}) =>
      HistoryState(records: records ?? this.records);

  int get totalFreed => records.fold(0, (sum, r) => sum + r.freedBytes);
}

class HistoryNotifier extends StateNotifier<HistoryState> {
  final HistoryRepository _repo;
  HistoryNotifier(this._repo) : super(const HistoryState());

  Future<void> load() async {
    state = HistoryState(records: await _repo.load());
  }

  Future<void> recordManual(String label, String package, int bytes) async {
    await _repo.add(CleanupRecord(
      timestamp: DateTime.now().toIso8601String(),
      appLabel: label.isEmpty ? package : label,
      appPackage: package,
      freedBytes: bytes,
      manual: true,
    ));
    state = HistoryState(records: await _repo.load());
  }

  Future<void> clear() async {
    await _repo.clear();
    state = const HistoryState();
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  return HistoryNotifier(ref.watch(historyRepositoryProvider));
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  final FavoritesRepository _repo;
  FavoritesNotifier(this._repo) : super(const <String>{});

  Future<void> load() async {
    state = await _repo.load();
  }

  Future<void> toggle(String package) async {
    final next = Set<String>.from(state);
    if (!next.add(package)) {
      next.remove(package);
    }
    state = next;
    await _repo.setFavorites(next);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier(ref.watch(favoritesRepositoryProvider));
});

Future<void> refreshAll(WidgetRef ref) async {
  ref.invalidate(batteryProvider);
  ref.invalidate(storageProvider);
  ref.invalidate(appsProvider);
}
