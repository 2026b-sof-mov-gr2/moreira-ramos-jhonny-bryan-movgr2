import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../routes.dart';
import '../../theme/app_theme.dart';

/// PANTALLA 2 del prototipo: "Tu pedido" con estado, línea de tiempo y QR.
/// Widgets: AppBar + BackButton, Card + CircleAvatar + Icon,
/// Column de Row (línea de tiempo), QrImageView, Text, FilledButton.
class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('Pedido recibido', '12:02', true),
      ('En preparación', '12:05', true),
      ('Listo para retirar', '12:11', true),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Tu pedido'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          // Tarjeta de estado
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            color: AppColors.primaryLight,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pedido #A-27',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '¡Está listo!',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: AppColors.dark,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Acércate a la ventanilla 2',
                            style: TextStyle(color: AppColors.textMuted)),
                        SizedBox(height: 4),
                        Text('Total pagado: \$4.25',
                            style: TextStyle(color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.success,
                    child: Icon(Icons.check_rounded,
                        color: Colors.white, size: 40),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Línea de tiempo
          ...List.generate(steps.length, (i) {
            final s = steps[i];
            final isLast = i == steps.length - 1;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 13,
                        backgroundColor:
                            s.$3 ? AppColors.primary : AppColors.border,
                        child: const Icon(Icons.check_rounded,
                            size: 16, color: Colors.white),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 3,
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 2, bottom: isLast ? 0 : 26),
                      child: Text(
                        s.$1,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.dark,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(s.$2,
                        style: const TextStyle(color: AppColors.textMuted)),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),

          // Código QR
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                const Text('Muestra este código al retirar',
                    style: TextStyle(color: AppColors.textMuted)),
                const SizedBox(height: 12),
                QrImageView(
                  data: 'FILACERO-PEDIDO-A-27',
                  version: QrVersions.auto,
                  size: 180,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 8),
                const Text(
                  'A-27',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, AppRoutes.rate),
            child: const Text('Ya lo retiré'),
          ),
        ),
      ),
    );
  }
}
