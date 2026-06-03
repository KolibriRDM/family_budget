import 'package:family_budget/app.dart';
import 'package:family_budget/app/di/di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await initDependencies(Environment.dev);
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pump();

    expect(find.byType(App), findsOneWidget);
  });
}
