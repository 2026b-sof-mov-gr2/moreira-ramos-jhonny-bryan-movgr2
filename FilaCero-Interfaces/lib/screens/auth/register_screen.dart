import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Regístrate con tus datos de estudiante para empezar a pedir sin fila.',
                style: TextStyle(fontSize: 15, color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),
              const LabeledField(
                label: 'Nombre completo',
                hint: 'Ej. Juan Pérez',
                icon: Icons.person_outline_rounded,
              ),
              const LabeledField(
                label: 'Código único / Cédula',
                hint: '202012345',
                icon: Icons.badge_outlined,
                keyboardType: TextInputType.number,
              ),
              const LabeledField(
                label: 'Correo institucional',
                hint: 'nombre.apellido@epn.edu.ec',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const Text(
                'Facultad',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.dark),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: 'Sistemas',
                isExpanded: true,
                decoration: const InputDecoration(
                  prefixIcon:
                      Icon(Icons.school_outlined, color: AppColors.textMuted),
                ),
                items: const [
                  'Sistemas',
                  'Eléctrica y Electrónica',
                  'Civil y Ambiental',
                  'Mecánica',
                  'Ciencias',
                ]
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: 16),
              const LabeledField(
                label: 'Contraseña',
                hint: 'Mínimo 8 caracteres',
                icon: Icons.lock_outline_rounded,
                obscure: true,
              ),
              const LabeledField(
                label: 'Confirmar contraseña',
                hint: 'Repite tu contraseña',
                icon: Icons.lock_outline_rounded,
                obscure: true,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(value: true, onChanged: (_) {}),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text.rich(
                        TextSpan(
                          text: 'Acepto los ',
                          children: [
                            TextSpan(
                              text: 'términos y condiciones',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(text: ' y la política de privacidad.'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.verify),
                child: const Text('Crear cuenta'),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text('¿Ya tienes cuenta?'),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Inicia sesión',
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
