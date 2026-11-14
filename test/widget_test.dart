import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:driva/main.dart';
import 'package:driva/ui/dashboard_screen.dart';

void main() {
  testWidgets('Driva app renders dashboard title', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: DrivaApp()));
    await tester.pump();

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Driva'), findsWidgets);
  });
}
