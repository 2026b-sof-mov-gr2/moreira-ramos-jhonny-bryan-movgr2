import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';

/// Logo de la app: un ícono de bandeja con el nombre.
class FilaCeroLogo extends StatelessWidget {
  final double size;
  final bool light;
  const FilaCeroLogo({super.key, this.size = 72, this.light = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: light ? Colors.white : AppColors.primary,
            borderRadius: BorderRadius.circular(size * 0.3),
          ),
          child: Icon(
            Icons.restaurant_menu_rounded,
            size: size * 0.5,
            color: light ? AppColors.primary : Colors.white,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'FilaCero',
          style: TextStyle(
            fontSize: size * 0.42,
            fontWeight: FontWeight.w900,
            color: light ? Colors.white : AppColors.dark,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

/// Campo de texto con etiqueta arriba (login, registro, pago).
class LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;

  const LabeledField({
    super.key,
    required this.label,
    required this.hint,
    this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: obscure,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: icon == null
                  ? null
                  : Icon(icon, color: AppColors.textMuted),
              suffixIcon: suffix,
            ),
          ),
        ],
      ),
    );
  }
}

/// Miniatura de color con ícono (reemplaza la "caja con X" del boceto).
class DishThumb extends StatelessWidget {
  final Dish dish;
  final double size;
  const DishThumb({super.key, required this.dish, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: dish.color,
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Icon(dish.icon, size: size * 0.48, color: Colors.white),
    );
  }
}

/// Tarjeta de plato: Card + ListTile + IconButton.filled (según el inventario).
class DishCard extends StatelessWidget {
  final Dish dish;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;
  const DishCard({super.key, required this.dish, this.onTap, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Opacity(
                opacity: dish.available ? 1 : 0.45,
                child: DishThumb(dish: dish),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dish.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    dish.available
                        ? Text(
                            money(dish.price),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          )
                        : const Text(
                            'Agotado',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.danger,
                            ),
                          ),
                  ],
                ),
              ),
              IconButton.filled(
                onPressed: dish.available ? (onAdd ?? () {}) : null,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.border,
                  fixedSize: const Size(44, 44),
                ),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Selector de cantidad  (-  1  +)
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final bool compact;
  const QuantitySelector({super.key, this.quantity = 1, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final s = compact ? 32.0 : 44.0;
    Widget btn(IconData icon) => SizedBox(
          width: s,
          height: s,
          child: IconButton.outlined(
            padding: EdgeInsets.zero,
            iconSize: compact ? 16 : 20,
            onPressed: () {},
            style: IconButton.styleFrom(
              side: const BorderSide(color: AppColors.border),
              backgroundColor: Colors.white,
            ),
            icon: Icon(icon, color: AppColors.dark),
          ),
        );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        btn(Icons.remove_rounded),
        SizedBox(
          width: compact ? 32 : 44,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 15 : 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        btn(Icons.add_rounded),
      ],
    );
  }
}

/// Fila "etiqueta ........ valor" para resúmenes de pago.
class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const SummaryRow(
      {super.key, required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 18 : 15,
      fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
      color: bold ? AppColors.dark : AppColors.textMuted,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}

/// Título de sección.
class SectionTitle extends StatelessWidget {
  final String text;
  final String? action;
  const SectionTitle(this.text, {super.key, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.dark,
              ),
            ),
          ),
          if (action != null)
            Text(
              action!,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}
