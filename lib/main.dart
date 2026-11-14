import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ui/dashboard_screen.dart';

void main() {
  runApp(const ProviderScope(child: DrivaApp()));
}

class DrivaApp extends StatelessWidget {
  const DrivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF00B894),
      brightness: Brightness.light,
    );
    return MaterialApp(
      title: 'Driva',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
