import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../theme/app_theme.dart';

/// Calificación después de retirar el pedido.
class RateOrderScreen extends StatelessWidget {
  const RateOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const rating = 4;
    final tags = ['Rápido', 'Buena porción', 'Rico', 'Caliente', 'Faltó algo'];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.home, (_) => false),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.emoji_food_beverage_rounded,
                  size: 80, color: AppColors.primary),
              const SizedBox(height: 16),
              const Text(
                '¿Qué tal tu pedido?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pedido #A-27 · Almuerzo del día, Jugo natural x2',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < rating ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 48,
                    color: const Color(0xFFFBBF24),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: tags
                    .map((t) => FilterChip(
                          label: Text(t),
                          selected: t == 'Rápido' || t == 'Rico',
                          onSelected: (_) {},
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              const TextField(
                maxLines: 3,
                decoration:
                    InputDecoration(hintText: 'Cuéntanos algo más (opcional)'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.home, (_) => false),
                child: const Text('Enviar calificación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
