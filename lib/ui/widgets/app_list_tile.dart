import 'package:flutter/material.dart';

import '../../core/models/app_info.dart';

class AppListTile extends StatelessWidget {
  final AppInfo app;
  final VoidCallback? onOpenSettings;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  const AppListTile({
    super.key,
    required this.app,
    this.onOpenSettings,
    this.isFavorite = false,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(app.label),
      subtitle: Text(app.package),
      leading: onToggleFavorite == null
          ? null
          : IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.amber : null,
              ),
              tooltip: isFavorite ? 'Quitar de favoritas' : 'Marcar favorita',
              onPressed: onToggleFavorite,
            ),
      trailing: onOpenSettings == null
          ? null
          : IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Limpiar en Ajustes',
              onPressed: onOpenSettings,
            ),
      onTap: onOpenSettings,
    );
  }
}
