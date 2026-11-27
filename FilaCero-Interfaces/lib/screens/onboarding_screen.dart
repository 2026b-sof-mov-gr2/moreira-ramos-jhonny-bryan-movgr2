import 'package:flutter/material.dart';

import '../routes.dart';
import '../theme/app_theme.dart';

/// 3 diapositivas que explican la propuesta: menú, pago, retiro con QR.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = [
    (
      icon: Icons.menu_book_rounded,
      color: AppColors.orange,
      title: 'Mira el menú del día',
      text: 'Platos, precios y disponibilidad en tiempo real antes de salir de clase.',
    ),
    (
      icon: Icons.shopping_bag_rounded,
      color: AppColors.green,
      title: 'Arma tu pedido y paga',
      text: 'Agrega platos con un toque y paga en la app, sin pasar por caja.',
    ),
    (
      icon: Icons.qr_code_2_rounded,
      color: AppColors.primarySoft,
      title: 'Retira con tu código',
      text: 'Te avisamos cuando esté listo. Muestras tu QR y listo: cero fila.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page == _pages.length - 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final last = _page == _pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, AppRoutes.login),
                  child: const Text('Saltar'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, i) {
                    final p = _pages[i];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            color: p.color,
                            borderRadius: BorderRadius.circular(64),
                          ),
                          child:
                              Icon(p.icon, size: 110, color: Colors.white),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          p.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          p.text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.4,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  final active = i == _page;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _next,
                child: Text(last ? 'Comenzar' : 'Siguiente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
