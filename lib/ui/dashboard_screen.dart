import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/app_info.dart';
import '../state/dashboard_providers.dart';
import 'history_screen.dart';
import 'widgets/app_list_tile.dart';
import 'widgets/battery_card.dart';
import 'widgets/storage_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showAllApps = false;

  static const _quickMbs = [10, 50, 100, 200, 500];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).load();
      ref.read(favoritesProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleOpenSettings(AppInfo app) async {
    await ref.read(cleanupServiceProvider).openAppSettings(app.package);
    if (!mounted) return;
    await _askFreedBytes(app);
  }

  Future<void> _askFreedBytes(AppInfo app) async {
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => _FreedBytesDialog(appLabel: app.label),
    );

    final mb = result;
    if (mb != null && mb > 0) {
      await ref
          .read(historyProvider.notifier)
          .recordManual(app.label, app.package, mb * 1024 * 1024);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrado: ${app.label} liberó $mb MB')),
        );
        refreshAll(ref);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final batteryAsync = ref.watch(batteryProvider);
    final storageAsync = ref.watch(storageProvider);
    final appsAsync = ref.watch(appsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driva'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
            tooltip: 'Historial y estadísticas',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => refreshAll(ref),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshAll(ref),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            batteryAsync.when(
              loading: () => const _LoadingCard(label: 'Cargando batería...'),
              error: (e, _) => _ErrorCard(message: '$e'),
              data: (battery) => BatteryCard(battery: battery),
            ),
            const SizedBox(height: 16),
            storageAsync.when(
              loading: () => const _LoadingCard(label: 'Cargando almacenamiento...'),
              error: (e, _) => _ErrorCard(message: '$e'),
              data: (storage) => StorageCard(storage: storage),
            ),
            const SizedBox(height: 24),
            _buildAppList(context, appsAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildAppList(BuildContext context, AsyncValue<List<AppInfo>> appsAsync) {
    return appsAsync.when(
      loading: () => const _LoadingCard(label: 'Cargando apps...'),
      error: (e, _) => _ErrorCard(message: '$e'),
      data: (apps) {
        final favorites = ref.watch(favoritesProvider);
        final records = ref.watch(historyProvider).records;

        final favApps = apps
            .where((a) => favorites.contains(a.package))
            .toList();
        final recentPackages = records
            .map((r) => r.appPackage)
            .toSet();
        final recentApps = apps
            .where((a) => recentPackages.contains(a.package))
            .toList();

        final filtered = _searchQuery.isEmpty
            ? apps
            : apps
                .where((a) =>
                    a.label.toLowerCase().contains(_searchQuery) ||
                    a.package.toLowerCase().contains(_searchQuery))
                .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mis apps', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Toca una app para abrir sus Ajustes y limpiar la caché. '
              'Marca las que limpies a menudo con ★ para tenerlas a mano.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar app...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
            ),
            const SizedBox(height: 8),

            if (_searchQuery.isNotEmpty) ...[
              if (filtered.isEmpty)
                _emptyMessage('No se encontraron apps')
              else
                ...filtered.map((app) => _tile(app)),
            ] else ...[
              _sectionHeader(context, 'Tus favoritas', icons: Icons.star),
              if (favApps.isEmpty)
                _inlineHint('Aún no marcas ninguna. Abajo puedes añadir con ★.')
              else
                ...favApps.map((app) => _tile(app)),
              if (recentApps.isNotEmpty) ...[
                _sectionHeader(context, 'Recientes'),
                ...recentApps.map((app) => _tile(app)),
              ],
              _sectionHeader(
                context,
                _showAllApps ? 'Todas las apps' : 'Todas las apps (${apps.length})',
                onTap: () => setState(() => _showAllApps = !_showAllApps),
                trailing: Icon(
                  _showAllApps ? Icons.expand_less : Icons.expand_more,
                ),
              ),
              if (_showAllApps)
                ...apps.map((app) => _tile(app)),
            ],
          ],
        );
      },
    );
  }

  Widget _tile(AppInfo app) {
    final isFav = ref.watch(favoritesProvider).contains(app.package);
    return AppListTile(
      app: app,
      onOpenSettings: () => _handleOpenSettings(app),
      isFavorite: isFav,
      onToggleFavorite: () =>
          ref.read(favoritesProvider.notifier).toggle(app.package),
    );
  }

  Widget _sectionHeader(BuildContext context, String title,
      {IconData? icons, VoidCallback? onTap, Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            if (icons != null) ...[
              Icon(icons, size: 18, color: Colors.amber),
              const SizedBox(width: 6),
            ],
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            ?trailing,
          ],
        ),
      ),
    );
  }

  Widget _inlineHint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }

  Widget _emptyMessage(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _FreedBytesDialog extends StatefulWidget {
  final String appLabel;
  const _FreedBytesDialog({required this.appLabel});

  @override
  State<_FreedBytesDialog> createState() => _FreedBytesDialogState();
}

class _FreedBytesDialogState extends State<_FreedBytesDialog> {
  final _controller = TextEditingController();
  int? _selected;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(int mb) {
    setState(() {
      _selected = mb;
      _controller.text = '$mb';
    });
  }

  int? get _parsed => int.tryParse(_controller.text);

  @override
  Widget build(BuildContext context) {
    final canSubmit = (_parsed ?? 0) > 0;
    return AlertDialog(
      title: Text('¿Cuánto liberaste en ${widget.appLabel}?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Android no deja ver la caché de cada app, así que el valor '
            'lo verás en los Ajustes de la app ("Almacenamiento → Borrar '
            'caché"). Escríbelo aquí o pulsa un valor rápido.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'MB liberados',
              border: OutlineInputBorder(),
              suffixText: 'MB',
            ),
            onChanged: (_) => setState(() => _selected = null),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final mb in _DashboardScreenState._quickMbs)
                ChoiceChip(
                  label: Text('$mb MB'),
                  selected: _selected == mb,
                  onSelected: (_) => _select(mb),
                ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: canSubmit
              ? () => Navigator.of(context).pop(_parsed)
              : null,
          child: const Text('Registrar'),
        ),
      ],
    );
  }
}

class _LoadingCard extends StatelessWidget {
  final String label;
  const _LoadingCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(message,
            style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer)),
      ),
    );
  }
}
