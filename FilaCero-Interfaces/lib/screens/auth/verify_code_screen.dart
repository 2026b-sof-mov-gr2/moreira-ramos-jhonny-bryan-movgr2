import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../theme/app_theme.dart';

/// Verificación del correo con un código de 4 dígitos.
class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const digits = ['4', '7', '1', ''];
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mark_email_read_rounded,
                      size: 48, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Verifica tu correo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enviamos un código de 4 dígitos a\nnombre.apellido@epn.edu.ec',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, height: 1.4),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: digits.map((d) {
                  final filled = d.isNotEmpty;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 60,
                    height: 68,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: filled ? AppColors.primary : AppColors.border,
                        width: filled ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      d,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text.rich(
                  TextSpan(
                    text: '¿No te llegó? ',
                    style: TextStyle(color: AppColors.textMuted),
                    children: [
                      TextSpan(
                        text: 'Reenviar en 0:45',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.home, (_) => false),
                child: const Text('Verificar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
