import 'package:flutter_test/flutter_test.dart';

import 'package:fila_cero_crud/main.dart';

void main() {
  testWidgets('Arranca en el login de FilaCero', (tester) async {
    await tester.pumpWidget(const FilaCeroCrudApp());
    await tester.pumpAndSettle();
    expect(find.text('FilaCero'), findsOneWidget);
  });
}
