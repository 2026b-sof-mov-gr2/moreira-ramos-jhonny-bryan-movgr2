import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fila_cero/routes.dart';
import 'package:fila_cero/theme/app_theme.dart';

void main() {
  for (final entry in AppRoutes.routes.entries) {
    if (entry.key == AppRoutes.splash) continue;
    testWidgets('Pantalla ${entry.key}', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light,
        home: Builder(builder: entry.value),
        routes: {
          for (final e in AppRoutes.routes.entries)
            if (e.key != '/') e.key: e.value
        },
      ));
      await tester.pumpAndSettle();
    });
  }
}
