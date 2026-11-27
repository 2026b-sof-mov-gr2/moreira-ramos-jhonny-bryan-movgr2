import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';
import 'order_form_screen.dart';

/// Detalle de un pedido (READ) con acciones Editar y Eliminar.
class OrderDetailScreen extends StatelessWidget {
  final Pedido pedido;
  const OrderDetailScreen({super.key, required this.pedido});

  Future<void> _eliminar(BuildContext context) async {
    final ok = await confirmar(
      context,
      titulo: '¿Eliminar pedido #${pedido.codigo}?',
      mensaje: pedido.estado == EstadoPedido.pendiente
          ? 'Se cancelará tu pedido, se devolverán los platos al menú'
              '${pedido.metodoPago == metodosPago.first ? ' y ${money(pedido.total)} a tu saldo' : ''}.'
          : 'Se quitará este pedido rechazado de tu historial.',
    );
    if (!ok || !context.mounted) return;
    final e = store.eliminarPedido(pedido);
    if (e != null) {
      toast(context, e, error: true);
      return;
    }
    toast(context, 'Pedido #${pedido.codigo} eliminado');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final p = pedido;
        final existe = store.pedidos.contains(p);
        final pasos = [
          EstadoPedido.pendiente,
          EstadoPedido.enPreparacion,
          EstadoPedido.listo,
          EstadoPedido.entregado,
        ];
        final idx = pasos.indexOf(p.estado);
        return Scaffold(
          appBar: AppBar(title: Text('Pedido #${p.codigo}')),
          body: !existe
              ? const Vacio(
                  icon: Icons.delete_outline_rounded,
                  titulo: 'Pedido eliminado',
                  texto: 'Este pedido ya no existe.')
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: p.estado.color.withAlpha(28),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pedido #${p.codigo}',
                                    style: TextStyle(
                                        color: p.estado.color,
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                Text(p.estado.label,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(height: 4),
                                Text(
                                    'Retiro: ${fechaCorta(p.retiro)} · ${hora(p.retiro)}',
                                    style: const TextStyle(
                                        color: AppColors.textMuted)),
                                if (p.motivoRechazo != null)
                                  Text('Motivo: ${p.motivoRechazo}',
                                      style: const TextStyle(
                                          color: AppColors.danger,
                                          fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: p.estado.color,
                            child: Icon(p.estado.icon,
                                color: Colors.white, size: 30),
                          ),
                        ],
                      ),
                    ),
                    if (idx >= 0) ...[
                      const SizedBox(height: 16),
                      ...List.generate(pasos.length, (i) {
                        final hecho = i <= idx;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: hecho
                                    ? AppColors.primary
                                    : AppColors.border,
                                child: const Icon(Icons.check_rounded,
                                    size: 14, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Text(pasos[i].label,
                                  style: TextStyle(
                                      fontWeight: hecho
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: hecho
                                          ? AppColors.dark
                                          : AppColors.textMuted)),
                            ],
                          ),
                        );
                      }),
                    ],
                    if (p.estado.activo) ...[
                      const SizedBox(height: 8),
                      Caja(
                        child: Column(
                          children: [
                            const Text('Muestra este código al retirar',
                                style: TextStyle(color: AppColors.textMuted)),
                            const SizedBox(height: 8),
                            QrImageView(
                              data: 'FILACERO-${p.codigo}-${p.usuarioId}',
                              size: 150,
                              backgroundColor: Colors.white,
                            ),
                            Text(p.codigo,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                    ],
                    const SectionTitle('Detalle'),
                    Caja(
                      child: Column(
                        children: [
                          ...p.items.map((i) => SummaryRow(
                              '${i.plato.nombre} x${i.cantidad}',
                              money(i.subtotal))),
                          if (p.paraLlevar)
                            SummaryRow('Táper', money(Pedido.cargoTaper)),
                          const Divider(height: 20),
                          SummaryRow('Total', money(p.total), bold: true),
                          const SizedBox(height: 6),
                          SummaryRow('Pago', p.metodoPago),
                          if (p.nota.isNotEmpty) SummaryRow('Nota', p.nota),
                        ],
                      ),
                    ),
                    if (!p.editable && p.estado.activo)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          'El comedor ya está atendiendo este pedido: ya no se '
                          'puede editar ni eliminar.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                  ],
                ),
          bottomNavigationBar: !existe || (!p.editable && !p.eliminable)
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: Row(
                      children: [
                        if (p.eliminable)
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.danger,
                                side:
                                    const BorderSide(color: AppColors.danger),
                              ),
                              onPressed: () => _eliminar(context),
                              icon: const Icon(Icons.delete_outline_rounded),
                              label: const Text('Eliminar'),
                            ),
                          ),
                        if (p.eliminable && p.editable)
                          const SizedBox(width: 12),
                        if (p.editable)
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        OrderFormScreen(pedido: p)),
                              ),
                              icon: const Icon(Icons.edit_rounded),
                              label: const Text('Editar'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
