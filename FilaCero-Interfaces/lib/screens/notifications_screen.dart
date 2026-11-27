import 'package:flutter/material.dart';

import '../routes.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        icon: Icons.check_circle_rounded,
        color: AppColors.success,
        title: 'Tu pedido #A-27 está listo',
        body: 'Acércate a la ventanilla 2 con tu código QR.',
        time: 'Hace 2 min',
        unread: true,
      ),
      (
        icon: Icons.soup_kitchen_rounded,
        color: AppColors.primary,
        title: 'Tu pedido está en preparación',
        body: 'Tiempo estimado: 6 minutos.',
        time: 'Hace 8 min',
        unread: true,
      ),
      (
        icon: Icons.restaurant_menu_rounded,
        color: AppColors.warning,
        title: 'Ya está el menú de hoy',
        body: 'Seco de pollo, menú vegetariano y más.',
        time: '10:30',
        unread: false,
      ),
      (
        icon: Icons.local_offer_rounded,
        color: AppColors.pink,
        title: '2x1 en jugos naturales',
        body: 'Válido hoy de 15:00 a 16:00.',
        time: 'Ayer',
        unread: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Marcar leídas')),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final n = items[i];
          return Material(
            color: n.unread ? AppColors.primaryLight : Colors.white,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppColors.border),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              onTap: i == 0
                  ? () => Navigator.pushNamed(context, AppRoutes.tracking)
                  : null,
              leading: CircleAvatar(
                backgroundColor: n.color,
                child: Icon(n.icon, color: Colors.white),
              ),
              title: Text(n.title,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(n.body),
              ),
              trailing: Text(n.time,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMuted)),
            ),
          );
        },
      ),
    );
  }
}
