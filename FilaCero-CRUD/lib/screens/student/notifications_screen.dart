import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final List<Notificacion> _lista = store.misNotificaciones;
  late final Set<Notificacion> _nuevas =
      _lista.where((n) => !n.leida).toSet();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => store.marcarLeidas());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: _lista.isEmpty
          ? const Vacio(
              icon: Icons.notifications_off_outlined,
              titulo: 'Sin notificaciones',
              texto: 'Aquí verás los avisos sobre tus pedidos.')
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              children: _lista
                  .map((n) => Tarjeta(
                        color: _nuevas.contains(n)
                            ? AppColors.primaryLight
                            : Colors.white,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: n.color,
                            child: Icon(n.icon, color: Colors.white),
                          ),
                          title: Text(n.titulo,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text(n.cuerpo),
                          trailing: Text(hora(n.fecha),
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.textMuted)),
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}
