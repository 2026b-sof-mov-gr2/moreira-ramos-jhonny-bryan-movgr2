import 'package:flutter_test/flutter_test.dart';

import 'package:fila_cero/main.dart';

void main() {
  testWidgets('La app arranca con el splash de FilaCero', (tester) async {
    await tester.pumpWidget(const FilaCeroApp());
    expect(find.text('FilaCero'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });
}
