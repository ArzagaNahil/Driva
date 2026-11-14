class StorageStats {
  final int totalBytes;
  final int freeBytes;
  final int cacheBytes;
  final int appCacheBytes;

  const StorageStats({
    required this.totalBytes,
    required this.freeBytes,
    required this.cacheBytes,
    required this.appCacheBytes,
  });

  int get usedBytes => totalBytes - freeBytes;

  factory StorageStats.fromJson(Map<String, dynamic> json) {
    return StorageStats(
      totalBytes: (json['total'] as num?)?.toInt() ?? 0,
      freeBytes: (json['free'] as num?)?.toInt() ?? 0,
      cacheBytes: (json['cached'] as num?)?.toInt() ?? 0,
      appCacheBytes: (json['appCache'] as num?)?.toInt() ?? 0,
    );
  }
}
