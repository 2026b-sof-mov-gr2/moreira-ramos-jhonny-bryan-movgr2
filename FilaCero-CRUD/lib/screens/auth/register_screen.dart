import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nombre = TextEditingController();
  final _correo = TextEditingController();
  final _pass = TextEditingController();
  final _pass2 = TextEditingController();

  @override
  void dispose() {
    for (final c in [_nombre, _correo, _pass, _pass2]) {
      c.dispose();
    }
    super.dispose();
  }

  void _crear() {
    FocusScope.of(context).unfocus();
    final error = store.registrar(
      nombre: _nombre.text,
      correo: _correo.text,
      password: _pass.text,
      confirmar: _pass2.text,
    );
    if (error != null) {
      toast(context, error, error: true);
      return;
    }
    toast(context, 'Cuenta creada. Tienes \$10.00 de saldo de bienvenida');
    irAlInicio(context);
  }

  Widget _campo(String label, TextEditingController c, IconData i,
      {bool oculto = false, String? hint, TextInputType? tipo}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: c,
            obscureText: oculto,
            keyboardType: tipo,
            decoration: InputDecoration(hintText: hint, prefixIcon: Icon(i)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
        children: [
          const Text(
            'Regístrate con tu correo institucional para pedir sin fila.',
            style: TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 20),
          _campo('Nombre completo', _nombre, Icons.person_outline_rounded,
              hint: 'Ej. Juan Pérez'),
          _campo('Correo institucional', _correo, Icons.mail_outline_rounded,
              hint: 'nombre.apellido@epn.edu.ec',
              tipo: TextInputType.emailAddress),
          _campo('Contraseña', _pass, Icons.lock_outline_rounded,
              oculto: true, hint: 'Mínimo 8 caracteres'),
          _campo('Confirmar contraseña', _pass2, Icons.lock_outline_rounded,
              oculto: true, hint: 'Repite tu contraseña'),
          const SizedBox(height: 8),
          FilledButton(onPressed: _crear, child: const Text('Crear cuenta')),
        ],
      ),
    );
  }
}
