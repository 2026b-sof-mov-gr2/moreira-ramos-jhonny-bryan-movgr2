import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: FilaCeroLogo(size: 72)),
              const SizedBox(height: 36),
              const Text(
                'Bienvenido de nuevo',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ingresa con tu correo institucional',
                style: TextStyle(fontSize: 15, color: AppColors.textMuted),
              ),
              const SizedBox(height: 28),
              const LabeledField(
                label: 'Correo institucional',
                hint: 'nombre.apellido@epn.edu.ec',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const LabeledField(
                label: 'Contraseña',
                hint: '••••••••',
                icon: Icons.lock_outline_rounded,
                obscure: true,
                suffix: Icon(Icons.visibility_off_outlined,
                    color: AppColors.textMuted),
              ),
              Row(
                children: [
                  Checkbox(value: true, onChanged: (_) {}),
                  const Text('Recordarme'),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.forgot),
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.home, (_) => false),
                child: const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('o continúa con',
                          style: TextStyle(color: AppColors.textMuted)),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.account_circle_outlined),
                label: const Text('Cuenta Microsoft EPN'),
              ),
              const SizedBox(height: 32),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text('¿No tienes cuenta?'),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.register),
                    child: const Text(
                      'Regístrate',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
