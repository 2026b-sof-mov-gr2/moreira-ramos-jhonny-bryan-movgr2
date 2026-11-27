import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

/// PANTALLA 1 del prototipo: Menú del día.
/// Widgets según el inventario: AppBar + CircleAvatar, Card +
/// LinearProgressIndicator, ChoiceChip, ListView + Card, IconButton.filled,
/// FloatingActionButton.extended + Badge.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _category = categories.first;

  @override
  Widget build(BuildContext context) {
    final list = dishes.where((d) => d.category == _category).toList();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 84,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, estudiante',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
              ),
            ),
            Text(
              'Comedor EPN',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.dark,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.notifications),
            icon: const Badge(
              smallSize: 8,
              child: Icon(Icons.notifications_none_rounded),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16, left: 4),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primaryLight,
              child: Text(
                'E',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
        backgroundColor: AppColors.dark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Badge(
          label: Text('2'),
          backgroundColor: AppColors.warning,
          child: Icon(Icons.shopping_bag_outlined),
        ),
        label: const Text(
          'Mi pedido',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
        children: [
          const _WaitTimeCard(),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar platos...',
              prefixIcon:
                  const Icon(Icons.search_rounded, color: AppColors.textMuted),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((c) {
                final selected = c == _category;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: selected,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _category = c),
                    selectedColor: AppColors.dark,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : AppColors.dark,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: selected ? AppColors.dark : AppColors.border,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          const SectionTitle('Menú de hoy'),
          ...list.map(
            (d) => DishCard(
              dish: d,
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.dishDetail,
                arguments: d,
              ),
              onAdd: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${d.name} agregado a tu pedido'),
                  duration: const Duration(seconds: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaitTimeCard extends StatelessWidget {
  const _WaitTimeCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text('Tiempo de espera',
                      style: TextStyle(color: Colors.white70, fontSize: 15)),
                ),
                Flexible(
                  child: Text('12 pedidos antes',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '≈ 5 min',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: LinearProgressIndicator(
                      value: 0.4,
                      minHeight: 8,
                      color: Colors.white,
                      backgroundColor: AppColors.primarySoft,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
