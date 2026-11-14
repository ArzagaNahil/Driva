import 'package:flutter/material.dart';

import '../../core/models/cleanup_result.dart';

class ResultDialog extends StatelessWidget {
  final CleanupResult result;

  const ResultDialog({super.key, required this.result});

  String _fmt(int bytes) {
    if (bytes >= 1048576) return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    if (bytes >= 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '$bytes B';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      icon: Icon(Icons.check_circle, color: colorScheme.primary, size: 56),
      title: const Text('Limpieza completada'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Liberaste ${_fmt(result.freedBytes)}',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${result.appsCleaned} apps limpiadas',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
