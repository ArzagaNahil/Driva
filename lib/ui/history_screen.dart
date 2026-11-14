import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/cleanup_record.dart';
import '../state/dashboard_providers.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _grouping = 'Día';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).load();
    });
  }

  String _fmt(int bytes) {
    if (bytes >= 1073741824) {
      return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
    }
    if (bytes >= 1048576) {
      return '${(bytes / 1048576).toStringAsFixed(0)} MB';
    }
    if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(0)} KB';
    }
    return '$bytes B';
  }

  List<CleanupRecord> get _records => ref.watch(historyProvider).records;
  int get _totalFreed => ref.watch(historyProvider).totalFreed;

  Map<String, int> _groupedBars() {
    final map = <String, int>{};
    for (final r in _records) {
      final dt = DateTime.tryParse(r.timestamp);
      if (dt == null) continue;
      final key = switch (_grouping) {
        'Día' => '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}',
        'Semana' => 'S${(dt.difference(DateTime(dt.year)).inDays ~/ 7) + 1}',
        _ => '${dt.month.toString().padLeft(2, '0')}/${dt.year}',
      };
      map[key] = (map[key] ?? 0) + r.freedBytes;
    }
    final list = map.entries.toList();
    list.sort((a, b) => b.key.compareTo(a.key));
    if (list.length > 15) {
      list.removeRange(15, list.length);
    }
    return Map.fromEntries(list);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bars = _groupedBars();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial y estadísticas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _records.isEmpty
                ? null
                : () async {
                    await ref.read(historyProvider.notifier).clear();
                  },
            tooltip: 'Borrar historial',
          ),
        ],
      ),
      body: _records.isEmpty
          ? const Center(child: Text('Aún no hay limpiezas registradas'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total liberado', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(
                          _fmt(_totalFreed),
                          style: theme.textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_records.length} limpiezas · ${_recordCountByPeriod()}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Limpiezas por periodo',
                                style: theme.textTheme.titleMedium),
                            DropdownButton<String>(
                              value: _grouping,
                              items: const [
                                DropdownMenuItem(value: 'Día', child: Text('Por día')),
                                DropdownMenuItem(
                                    value: 'Semana', child: Text('Por semana')),
                                DropdownMenuItem(value: 'Mes', child: Text('Por mes')),
                              ],
                              onChanged: (v) =>
                                  setState(() => _grouping = v ?? 'Día'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 180,
                          child: _Chart(bars: bars),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Últimas limpiezas', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                ..._records.take(20).map((r) => _recordTile(r)),
              ],
            ),
    );
  }

  String _recordCountByPeriod() {
    final now = DateTime.now();
    final week = _records
        .where((r) {
          final dt = DateTime.tryParse(r.timestamp);
          return dt != null && now.difference(dt).inDays <= 7;
        })
        .toList();
    return '${week.length} esta semana';
  }

  Widget _recordTile(CleanupRecord r) {
    final dt = DateTime.tryParse(r.timestamp);
    final label = dt == null
        ? r.timestamp
        : '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return ListTile(
      dense: true,
      leading: const Icon(Icons.cleaning_services),
      title: Text(r.appLabel),
      subtitle: Text('$label · liberó ${_fmt(r.freedBytes)}'),
    );
  }
}

class _Chart extends StatelessWidget {
  final Map<String, int> bars;
  const _Chart({required this.bars});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (bars.isEmpty) {
      return const Center(child: Text('Sin datos para el gráfico'));
    }
    final maxVal = bars.values.fold<int>(0, (a, b) => a > b ? a : b);
    final spots = <BarChartGroupData>[];
    var i = 0;
    bars.forEach((label, value) {
      spots.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: maxVal == 0 ? 1 : value.toDouble(),
            color: colorScheme.primary,
            width: 18,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      ));
      i++;
    });

    return BarChart(
      BarChartData(
        maxY: maxVal.toDouble() * 1.2,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => colorScheme.inverseSurface,
            tooltipRoundedRadius: 6,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final label = bars.keys.elementAt(group.x);
              return BarTooltipItem(
                '$label\n${_fmtBytes(rod.toY.round())}',
                TextStyle(color: colorScheme.inversePrimary),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= bars.keys.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    bars.keys.elementAt(idx),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barGroups: spots,
      ),
    );
  }

  String _fmtBytes(int bytes) {
    if (bytes >= 1073741824) {
      return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
    }
    if (bytes >= 1048576) {
      return '${(bytes / 1048576).toStringAsFixed(0)} MB';
    }
    return '$bytes B';
  }
}
