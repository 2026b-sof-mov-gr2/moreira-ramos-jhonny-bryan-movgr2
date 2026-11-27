import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

/// Detalle de un plato: foto, descripción, opciones y cantidad.
class DishDetailScreen extends StatelessWidget {
  const DishDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final dish = arg is Dish ? arg : dishes.first;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: dish.color,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: AppColors.dark),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border_rounded,
                        color: AppColors.dark),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: dish.color,
                child: Icon(dish.icon, size: 140, color: Colors.white),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dish.name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: AppColors.dark,
                          ),
                        ),
                      ),
                      Text(
                        money(dish.price),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dish.description,
                    style: const TextStyle(
                        fontSize: 16, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 16),
                  const Wrap(
                    spacing: 8,
                    children: [
                      _InfoChip(icon: Icons.timer_outlined, text: '5-8 min'),
                      _InfoChip(
                          icon: Icons.local_fire_department_outlined,
                          text: '650 kcal'),
                      _InfoChip(
                          icon: Icons.inventory_2_outlined,
                          text: '18 disponibles'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const SectionTitle('Elige tu jugo'),
                  RadioGroup<String>(
                    groupValue: 'Mora',
                    onChanged: (_) {},
                    child: Column(
                      children: ['Mora', 'Naranja', 'Maracuyá']
                          .map(
                            (j) => RadioListTile<String>(
                              value: j,
                              title: Text(j),
                              contentPadding: EdgeInsets.zero,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SectionTitle('Extras'),
                  CheckboxListTile(
                    value: false,
                    onChanged: (_) {},
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Porción extra de arroz'),
                    secondary: const Text('+\$0.50'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    value: true,
                    onChanged: (_) {},
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Para llevar (táper)'),
                    secondary: const Text('+\$0.25'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 8),
                  const SectionTitle('Nota para cocina'),
                  const TextField(
                    maxLines: 2,
                    decoration:
                        InputDecoration(hintText: 'Ej. sin cebolla, poca sal'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              const QuantitySelector(quantity: 1),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, AppRoutes.cart),
                  child: Text('Agregar · ${money(dish.price + 0.25)}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: AppColors.primary),
      label: Text(text),
      backgroundColor: AppColors.primaryLight,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
