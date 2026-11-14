class BatteryHealth {
  final int level;
  final bool charging;
  final double temperatureC;

  const BatteryHealth({
    required this.level,
    required this.charging,
    required this.temperatureC,
  });

  factory BatteryHealth.fromJson(Map<String, dynamic> json) {
    return BatteryHealth(
      level: (json['level'] as num?)?.toInt() ?? 0,
      charging: json['charging'] as bool? ?? false,
      temperatureC: (json['temperature_c'] as num?)?.toDouble() ?? 0,
    );
  }
}
