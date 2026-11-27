import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';
import '../staff/staff_shell.dart';
import '../student/student_shell.dart';
import 'register_screen.dart';

void irAlInicio(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) => store.esComedor ? const StaffShell() : const StudentShell(),
    ),
    (_) => false,
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _correo = TextEditingController();
  final _pass = TextEditingController();
  bool _ver = false;

  @override
  void dispose() {
    _correo.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _entrar() {
    FocusScope.of(context).unfocus();
    final error = store.login(_correo.text, _pass.text);
    if (error != null) {
      toast(context, error, error: true);
      return;
    }
    toast(context, 'Bienvenido, ${store.actual!.nombre}');
    irAlInicio(context);
  }

  void _usar(String correo, String pass) {
    setState(() {
      _correo.text = correo;
      _pass.text = pass;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          children: [
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.restaurant_menu_rounded,
                    size: 36, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            const Text('FilaCero',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
            const Text('Pide en el comedor sin hacer fila',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 28),
            const Text('Correo institucional',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _correo,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'nombre.apellido@epn.edu.ec',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Contraseña',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _pass,
              obscureText: !_ver,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _ver = !_ver),
                  icon: Icon(_ver
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _entrar,
              child: const Text('Iniciar sesión'),
            ),
            const SizedBox(height: 20),
            Caja(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Cuentas de prueba (datos en memoria)',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                          fontSize: 13)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(46)),
                          onPressed: () => _usar(
                              'jhonny.moreira@epn.edu.ec', 'filacero123'),
                          icon: const Icon(Icons.school_outlined, size: 20),
                          label: const Text('Estudiante'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(46)),
                          onPressed: () =>
                              _usar('comedor@epn.edu.ec', 'comedor123'),
                          icon: const Icon(Icons.storefront_outlined,
                              size: 20),
                          label: const Text('Comedor'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('¿No tienes cuenta?'),
                TextButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen())),
                  child: const Text('Regístrate',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
