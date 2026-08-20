import 'package:flutter_test/flutter_test.dart';
import 'package:stock_ledger/main.dart';

void main() {
  testWidgets('App compiles smoke test', (WidgetTester tester) async {
    // We updated MyApp() to StockLedgerApp()
    await tester.pumpWidget(const StockLedgerApp());
  });
}
