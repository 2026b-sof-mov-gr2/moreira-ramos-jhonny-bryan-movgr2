import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../routes.dart';
import '../../theme/app_theme.dart';

/// Pestaña "Pedidos": pedido activo + historial.
class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  Color _statusColor(String s) {
    switch (s) {
      case 'Listo':
        return AppColors.success;
      case 'Cancelado':
        return AppColors.danger;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis pedidos'),
          bottom: const TabBar(
            labelColor: AppColors.primary,
            indicatorColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            labelStyle: TextStyle(fontWeight: FontWeight.w700),
            tabs: [Tab(text: 'Activos'), Tab(text: 'Historial')],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(20),
              children: [_orderTile(context, pastOrders.first, active: true)],
            ),
            ListView(
              padding: const EdgeInsets.all(20),
              children: pastOrders
                  .skip(1)
                  .map((o) => _orderTile(context, o))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderTile(BuildContext context, PastOrder o, {bool active = false}) {
    final color = _statusColor(o.status);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
            color: active ? AppColors.primary : AppColors.border,
            width: active ? 2 : 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        onTap: () => Navigator.pushNamed(context, AppRoutes.tracking),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: AppColors.primaryLight,
          child: Text(
            o.code,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ),
        title: Text(o.items,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Text(o.date),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  o.status,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(money(o.total),
                style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 15)),
            if (!active)
              const Text('Repetir',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12)),
          ],
        ),
      ),
      ),
    );
  }
}
