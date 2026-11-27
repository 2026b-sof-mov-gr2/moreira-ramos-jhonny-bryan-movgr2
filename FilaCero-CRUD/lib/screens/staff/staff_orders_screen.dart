import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';
import '../student/my_orders_screen.dart';

/// El comedor ve todos los pedidos, los avanza de estado o los rechaza.
class StaffOrdersScreen extends StatefulWidget {
  const StaffOrdersScreen({super.key});

  @override
  State<StaffOrdersScreen> createState() => _StaffOrdersScreenState();
}

class _StaffOrdersScreenState extends State<StaffOrdersScreen> {
  EstadoPedido? _filtro = EstadoPedido.pendiente;

  String _accion(EstadoPedido sig) => switch (sig) {
        EstadoPedido.enPreparacion => 'Preparar',
        EstadoPedido.listo => 'Marcar listo',
        _ => 'Entregar',
      };

  Future<void> _rechazar(Pedido p) async {
    final motivo = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.cancel_outlined,
            color: AppColors.danger, size: 36),
        title: Text('Rechazar pedido #${p.codigo}'),
        contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Elige el motivo. El estudiante recibirá un aviso.'),
            const SizedBox(height: 8),
            ...motivosRechazo.map((m) => ListTile(
                  dense: true,
                  leading: const Icon(Icons.chevron_right_rounded),
                  title: Text(m),
                  onTap: () => Navigator.pop(ctx, m),
                )),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
        ],
      ),
    );
    if (motivo == null || !mounted) return;
    final e = store.rechazarPedido(p, motivo);
    toast(context, e ?? 'Pedido #${p.codigo} rechazado', error: e != null);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final lista = store.pedidosPorEstado(_filtro);
        int cuenta(EstadoPedido? e) => store.pedidosPorEstado(e).length;
        return Scaffold(
          appBar: AppBar(title: const Text('Pedidos del comedor')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [null, ...EstadoPedido.values].map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('${e?.label ?? 'Todos'} (${cuenta(e)})'),
                        selected: _filtro == e,
                        onSelected: (_) => setState(() => _filtro = e),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              if (lista.isEmpty)
                const Vacio(
                    icon: Icons.inbox_rounded,
                    titulo: 'Sin pedidos',
                    texto: 'No hay pedidos con este estado.'),
              ...lista.map((p) {
                final sig = store.siguienteEstado(p);
                final quien = store.usuario(p.usuarioId)?.nombre ?? '';
                return PedidoTile(
                  pedido: p,
                  subtitulo: '$quien · ${p.resumen}',
                  onTap: () {},
                  acciones: sig == null
                      ? null
                      : Row(
                          children: [
                            if (p.estado == EstadoPedido.pendiente)
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(42),
                                    foregroundColor: AppColors.danger,
                                  ),
                                  onPressed: () => _rechazar(p),
                                  child: const Text('Rechazar'),
                                ),
                              ),
                            if (p.estado == EstadoPedido.pendiente)
                              const SizedBox(width: 10),
                            Expanded(
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                    minimumSize: const Size.fromHeight(42)),
                                onPressed: () {
                                  final e = store.avanzarEstado(p);
                                  toast(
                                      context,
                                      e ??
                                          'Pedido #${p.codigo}: ${p.estado.label.toLowerCase()}',
                                      error: e != null);
                                },
                                child: Text(_accion(sig)),
                              ),
                            ),
                          ],
                        ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
