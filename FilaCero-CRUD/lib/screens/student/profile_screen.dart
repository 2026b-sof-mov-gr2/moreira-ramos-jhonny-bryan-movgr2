import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';
import '../auth/login_screen.dart';

/// Perfil compartido por estudiante y comedor.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _salir(BuildContext context) async {
    final ok = await confirmar(context,
        titulo: '¿Cerrar sesión?',
        mensaje: 'Los datos siguen en memoria mientras la app esté abierta.',
        aceptar: 'Salir',
        peligro: false,
        icon: Icons.logout_rounded);
    if (!ok || !context.mounted) return;
    store.logout();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final u = store.actual;
        if (u == null) return const Scaffold();
        final mios = store.misPedidos;
        return Scaffold(
          appBar: AppBar(title: const Text('Perfil')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              Caja(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(u.inicial,
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u.nombre,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800)),
                          Text(u.correo,
                              style:
                                  const TextStyle(color: AppColors.textMuted)),
                          const SizedBox(height: 4),
                          Text(
                              u.rol == Rol.comedor
                                  ? 'Personal del comedor'
                                  : 'Estudiante',
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              if (u.rol == Rol.estudiante)
                Row(
                  children: [
                    _Dato('Saldo', money(u.saldo)),
                    const SizedBox(width: 10),
                    _Dato('Pedidos', '${mios.length}'),
                    const SizedBox(width: 10),
                    _Dato('En curso',
                        '${mios.where((p) => p.estado.activo).length}'),
                  ],
                )
              else
                Row(
                  children: [
                    _Dato('Platos', '${store.platos.length}'),
                    const SizedBox(width: 10),
                    _Dato('Pedidos', '${store.pedidos.length}'),
                    const SizedBox(width: 10),
                    _Dato('Usuarios', '${store.usuarios.length}'),
                  ],
                ),
              const SizedBox(height: 20),
              Tarjeta(
                child: ListTile(
                  leading:
                      const Icon(Icons.logout_rounded, color: AppColors.danger),
                  title: const Text('Cerrar sesión',
                      style: TextStyle(
                          color: AppColors.danger,
                          fontWeight: FontWeight.w700)),
                  onTap: () => _salir(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Dato extends StatelessWidget {
  final String label;
  final String valor;
  const _Dato(this.label, this.valor);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Caja(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(valor,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary)),
            Text(label,
                style:
                    const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
