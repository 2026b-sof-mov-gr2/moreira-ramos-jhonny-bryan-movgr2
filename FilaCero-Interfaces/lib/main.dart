import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FilaCeroApp());
}

class FilaCeroApp extends StatelessWidget {
  const FilaCeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FilaCero',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
