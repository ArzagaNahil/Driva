class AppInfo {
  final String package;
  final String label;
  final int cacheBytes;

  const AppInfo({
    required this.package,
    required this.label,
    required this.cacheBytes,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      package: json['package'] as String? ?? '',
      label: json['label'] as String? ?? '',
      cacheBytes: (json['cacheBytes'] as num?)?.toInt() ?? 0,
    );
  }
}
