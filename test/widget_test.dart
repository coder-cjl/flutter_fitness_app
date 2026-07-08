import 'package:fitness_app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home tab is displayed in tab container', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: DLApp()));
    await tester.pumpAndSettle();

    expect(find.text('首页'), findsWidgets);
  });
}
