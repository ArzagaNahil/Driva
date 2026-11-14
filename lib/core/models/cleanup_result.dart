class CleanupResult {
  final int freedBytes;
  final int appsCleaned;

  const CleanupResult({
    required this.freedBytes,
    required this.appsCleaned,
  });

  factory CleanupResult.fromJson(Map<String, dynamic> json) {
    return CleanupResult(
      freedBytes: (json['freedBytes'] as num?)?.toInt() ?? 0,
      appsCleaned: (json['appsCleaned'] as num?)?.toInt() ?? 0,
    );
  }
}
