import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../theme/app_theme.dart';

/// Pestaña "Perfil".
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 34,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    'E',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Estudiante EPN',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w800)),
                      SizedBox(height: 2),
                      Text('estudiante@epn.edu.ec',
                          style: TextStyle(color: AppColors.textMuted)),
                      SizedBox(height: 2),
                      Text('Facultad de Ingeniería de Sistemas',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.editProfile),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Saldo y estadísticas
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Saldo FilaCero',
                          style: TextStyle(color: Colors.white70)),
                      SizedBox(height: 4),
                      Text('\$12.50',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () {},
                  child: const Text('Recargar'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              _Stat(value: '23', label: 'Pedidos'),
              SizedBox(width: 12),
              _Stat(value: '3.8 h', label: 'Fila ahorrada'),
              SizedBox(width: 12),
              _Stat(value: '4.8', label: 'Calificación'),
            ],
          ),
          const SizedBox(height: 20),
          _group([
            _tile(context, Icons.person_outline_rounded, 'Editar perfil',
                route: AppRoutes.editProfile),
            _tile(context, Icons.notifications_none_rounded, 'Notificaciones',
                route: AppRoutes.notifications),
            _tile(context, Icons.credit_card_rounded, 'Métodos de pago'),
            _tile(context, Icons.favorite_border_rounded, 'Platos favoritos'),
          ]),
          const SizedBox(height: 12),
          _group([
            _tile(context, Icons.help_outline_rounded, 'Ayuda y soporte'),
            _tile(context, Icons.description_outlined, 'Términos y privacidad'),
            _tile(context, Icons.info_outline_rounded, 'Acerca de FilaCero'),
          ]),
          const SizedBox(height: 12),
          _group([
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: AppColors.danger),
              title: const Text('Cerrar sesión',
                  style: TextStyle(
                      color: AppColors.danger, fontWeight: FontWeight.w700)),
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.login, (_) => false),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _group(List<Widget> children) => Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Column(children: children),
      );

  Widget _tile(BuildContext context, IconData icon, String title,
      {String? route}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.dark),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: AppColors.textMuted),
      onTap: route == null ? () {} : () => Navigator.pushNamed(context, route),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary)),
            const SizedBox(height: 2),
            Text(label,
                style:
                    const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
