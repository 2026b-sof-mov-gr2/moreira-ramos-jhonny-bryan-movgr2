import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';
import 'order_detail_screen.dart';

/// Lista (READ) de los pedidos del estudiante: en curso e historial.
class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final todos = store.misPedidos;
        final curso = todos.where((p) => p.estado.activo).toList();
        final hist = todos.where((p) => !p.estado.activo).toList();
        return Scaffold(
          appBar: AppBar(title: const Text('Mis pedidos')),
          body: todos.isEmpty
              ? const Vacio(
                  icon: Icons.receipt_long_rounded,
                  titulo: 'Aún no tienes pedidos',
                  texto: 'Agrega platos desde el menú para crear uno.')
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  children: [
                    SectionTitle('En curso (${curso.length})'),
                    if (curso.isEmpty)
                      const Text('No tienes pedidos en curso.',
                          style: TextStyle(color: AppColors.textMuted)),
                    ...curso.map((p) => PedidoTile(pedido: p)),
                    SectionTitle('Historial (${hist.length})'),
                    ...hist.map((p) => PedidoTile(pedido: p)),
                  ],
                ),
        );
      },
    );
  }
}

class PedidoTile extends StatelessWidget {
  final Pedido pedido;
  final String? subtitulo;
  final Widget? acciones;
  final VoidCallback? onTap;
  const PedidoTile(
      {super.key, required this.pedido, this.subtitulo, this.acciones, this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = pedido;
    return Tarjeta(
      borde: p.estado == EstadoPedido.pendiente
          ? AppColors.warning
          : AppColors.border,
      onTap: onTap ??
          () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => OrderDetailScreen(pedido: p)),
              ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(p.codigo,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subtitulo ?? p.resumen,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                                '${fechaCorta(p.retiro)} · ${hora(p.retiro)}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted)),
                          ),
                          const SizedBox(width: 8),
                          EstadoChip(p.estado),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(money(p.total),
                    style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
            if (acciones != null) ...[
              const SizedBox(height: 10),
              acciones!,
            ],
          ],
        ),
      ),
    );
  }
}
