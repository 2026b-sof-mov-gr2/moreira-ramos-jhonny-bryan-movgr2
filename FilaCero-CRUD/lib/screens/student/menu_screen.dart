import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';
import 'notifications_screen.dart';
import 'order_form_screen.dart';

/// Menú del día (lee los platos de la memoria) y carrito.
class MenuScreen extends StatefulWidget {
  final VoidCallback onVerPedidos;
  const MenuScreen({super.key, required this.onVerPedidos});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _cat = categorias.first;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final u = store.actual;
        final lista = store.platos.where((p) => p.categoria == _cat).toList();
        final enCola = store.pedidos
            .where((p) =>
                p.estado == EstadoPedido.pendiente ||
                p.estado == EstadoPedido.enPreparacion)
            .length;
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 76,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hola, ${u?.nombre.split(' ').first ?? ''}',
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500)),
                const Text('Comedor EPN',
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationsScreen())),
                icon: Badge(
                  isLabelVisible: store.noLeidas > 0,
                  label: Text('${store.noLeidas}'),
                  child: const Icon(Icons.notifications_none_rounded),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 4),
                child: Chip(
                  avatar: const Icon(Icons.account_balance_wallet_rounded,
                      size: 18, color: AppColors.primary),
                  label: Text(money(u?.saldo ?? 0),
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  backgroundColor: AppColors.primaryLight,
                  side: BorderSide.none,
                ),
              ),
            ],
          ),
          floatingActionButton: store.unidadesCarrito == 0
              ? null
              : FloatingActionButton.extended(
                  backgroundColor: AppColors.dark,
                  foregroundColor: Colors.white,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrderFormScreen()),
                  ),
                  icon: Badge(
                    label: Text('${store.unidadesCarrito}'),
                    backgroundColor: AppColors.warning,
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                  label: const Text('Mi pedido',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tiempo de espera',
                              style: TextStyle(color: Colors.white70)),
                          Text('≈ ${2 + enCola * 2} min',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                    Text('$enCola pedidos\nen cola',
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categorias.map((c) {
                    final sel = c == _cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(c),
                        selected: sel,
                        showCheckmark: false,
                        onSelected: (_) => setState(() => _cat = c),
                        selectedColor: AppColors.dark,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: sel ? Colors.white : AppColors.dark),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                              color: sel ? AppColors.dark : AppColors.border),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SectionTitle('Menú de hoy'),
              if (lista.isEmpty)
                const Vacio(
                    icon: Icons.no_meals_rounded,
                    titulo: 'Sin platos',
                    texto: 'No hay platos en esta categoría.'),
              ...lista.map((p) => _PlatoCard(plato: p)),
            ],
          ),
        );
      },
    );
  }
}

class _PlatoCard extends StatelessWidget {
  final Plato plato;
  const _PlatoCard({required this.plato});

  @override
  Widget build(BuildContext context) {
    final enCarrito = store.carrito
        .where((i) => i.plato.id == plato.id)
        .fold<int>(0, (s, i) => s + i.cantidad);
    final estado = !plato.disponible
        ? const Text('No disponible',
            style: TextStyle(
                color: AppColors.danger, fontWeight: FontWeight.w700))
        : plato.stock == 0
            ? const Text('Agotado',
                style: TextStyle(
                    color: AppColors.danger, fontWeight: FontWeight.w700))
            : Text('${plato.stock} disponibles',
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 12));
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Caja(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          PlatoThumb(plato: plato),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plato.nombre,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                Text(plato.descripcion,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(money(plato.precio),
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary)),
                    const SizedBox(width: 8),
                    Flexible(child: estado),
                  ],
                ),
              ],
            ),
          ),
          Badge(
            isLabelVisible: enCarrito > 0,
            label: Text('$enCarrito'),
            backgroundColor: AppColors.warning,
            child: IconButton.filled(
              onPressed: plato.sePuedePedir
                  ? () {
                      final e = store.agregarAlCarrito(plato);
                      toast(context, e ?? '${plato.nombre} agregado',
                          error: e != null);
                    }
                  : null,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.border,
              ),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
