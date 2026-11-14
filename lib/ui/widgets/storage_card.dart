import 'package:flutter/material.dart';

import '../../core/models/storage_stats.dart';

class StorageCard extends StatelessWidget {
  final StorageStats storage;
  final int? freedBytes;

  const StorageCard({super.key, required this.storage, this.freedBytes});

  String _fmt(int bytes) {
    if (bytes >= 1073741824) return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
    if (bytes >= 1048576) return '${(bytes / 1048576).toStringAsFixed(0)} MB';
    if (bytes >= 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '$bytes B';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final used = storage.usedBytes;
    final total = storage.totalBytes;
    final fraction = total == 0 ? 0.0 : (used / total).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sd_storage, size: 28, color: colorScheme.primary),
                const SizedBox(width: 12),
                Text('Almacenamiento', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 10,
                backgroundColor: colorScheme.surfaceContainerHighest,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_fmt(used)} de ${_fmt(total)} usados',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (freedBytes != null && freedBytes! > 0) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Has liberado ${_fmt(freedBytes!)}',
                  style: TextStyle(color: colorScheme.onSecondaryContainer),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
