import 'package:flutter/material.dart';

import '../../core/models/battery_health.dart';

class BatteryCard extends StatelessWidget {
  final BatteryHealth battery;

  const BatteryCard({super.key, required this.battery});

  String get _tempText {
    final t = battery.temperatureC;
    return '${t.toStringAsFixed(1)}°C';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.battery_charging_full,
              size: 48,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Batería',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${battery.level}%',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${battery.charging ? 'Cargando • ' : ''}$_tempText',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
