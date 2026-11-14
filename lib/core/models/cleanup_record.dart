class CleanupRecord {
  final String timestamp;
  final String appLabel;
  final String appPackage;
  final int freedBytes;
  final bool manual;

  const CleanupRecord({
    required this.timestamp,
    required this.appLabel,
    required this.appPackage,
    required this.freedBytes,
    this.manual = true,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'appLabel': appLabel,
        'appPackage': appPackage,
        'freedBytes': freedBytes,
        'manual': manual,
      };

  factory CleanupRecord.fromJson(Map<String, dynamic> json) => CleanupRecord(
        timestamp: json['timestamp'] as String? ?? '',
        appLabel: json['appLabel'] as String? ?? 'App',
        appPackage: json['appPackage'] as String? ?? '',
        freedBytes: (json['freedBytes'] as num?)?.toInt() ?? 0,
        manual: json['manual'] as bool? ?? true,
      );
}
