import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

/// Carrito / "Mi pedido": revisar platos antes de pagar.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (dish: dishes[0], qty: 1),
      (dish: dishes[5], qty: 2),
    ];
    const subtotal = 4.00;
    const service = 0.25;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi pedido')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.storefront_rounded, color: AppColors.primary),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Retiro en Comedor EPN · Ventanilla 2',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...items.map(
            (it) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  DishThumb(dish: it.dish, size: 56),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(it.dish.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(
                          money(it.dish.price * it.qty),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  QuantitySelector(quantity: it.qty, compact: true),
                ],
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Agregar más platos'),
          ),
          const SizedBox(height: 12),
          const SectionTitle('Hora de retiro'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ['Lo antes posible', '12:30', '13:00', '13:30']
                .map(
                  (h) => ChoiceChip(
                    label: Text(h),
                    selected: h == 'Lo antes posible',
                    onSelected: (_) {},
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                SummaryRow(label: 'Subtotal', value: money(subtotal)),
                SummaryRow(label: 'Servicio', value: money(service)),
                const Divider(height: 24),
                SummaryRow(
                    label: 'Total', value: money(subtotal + service), bold: true),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.payment),
            child: Text('Ir a pagar · ${money(subtotal + service)}'),
          ),
        ),
      ),
    );
  }
}
