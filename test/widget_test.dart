import 'package:flutter_test/flutter_test.dart';
import 'package:barely_shop/main.dart';

void main() {
  testWidgets('BarelyShop smoke test - launches and displays login',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BarelyShopApp());
    await tester.pumpAndSettle();

    expect(find.text('barely_shop'), findsOneWidget);
    expect(find.text('Masuk'), findsWidgets);
  });
}
