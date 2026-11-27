import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';

/// "Toast": SnackBar flotante, verde si salió bien y rojo si es un error.
void toast(BuildContext context, String msg, {bool error = false}) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: error ? AppColors.danger : AppColors.dark,
    duration: const Duration(milliseconds: 2600),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    content: Row(
      children: [
        Icon(error ? Icons.error_outline_rounded : Icons.check_circle_rounded,
            color: error ? Colors.white : const Color(0xFF4ADE80)),
        const SizedBox(width: 10),
        Expanded(child: Text(msg)),
      ],
    ),
  ));
}

/// Diálogo de confirmación (AlertDialog). Devuelve true si confirma.
Future<bool> confirmar(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  String aceptar = 'Eliminar',
  bool peligro = true,
  IconData icon = Icons.delete_outline_rounded,
}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: Icon(icon,
          size: 36, color: peligro ? AppColors.danger : AppColors.primary),
      title: Text(titulo, textAlign: TextAlign.center),
      content: Text(mensaje, textAlign: TextAlign.center),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(120, 44),
            backgroundColor: peligro ? AppColors.danger : AppColors.primary,
          ),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(aceptar),
        ),
      ],
    ),
  );
  return r ?? false;
}

/// Miniatura de color con ícono del plato.
class PlatoThumb extends StatelessWidget {
  final Plato plato;
  final double size;
  const PlatoThumb({super.key, required this.plato, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: plato.sePuedePedir ? 1 : 0.45,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: plato.color,
          borderRadius: BorderRadius.circular(size * 0.25),
        ),
        child: Icon(plato.icon, size: size * 0.5, color: Colors.white),
      ),
    );
  }
}

/// Etiqueta de estado de un pedido.
class EstadoChip extends StatelessWidget {
  final EstadoPedido estado;
  const EstadoChip(this.estado, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: estado.color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(estado.icon, size: 14, color: estado.color),
          const SizedBox(width: 4),
          Text(
            estado.label,
            style: TextStyle(
              color: estado.color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Selector de cantidad (-  n  +).
class Cantidad extends StatelessWidget {
  final int valor;
  final VoidCallback? onMenos;
  final VoidCallback? onMas;
  const Cantidad({super.key, required this.valor, this.onMenos, this.onMas});

  @override
  Widget build(BuildContext context) {
    Widget b(IconData i, VoidCallback? f) => SizedBox(
          width: 34,
          height: 34,
          child: IconButton.outlined(
            padding: EdgeInsets.zero,
            iconSize: 18,
            onPressed: f,
            style: IconButton.styleFrom(
              side: const BorderSide(color: AppColors.border),
              backgroundColor: Colors.white,
            ),
            icon: Icon(i),
          ),
        );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        b(Icons.remove_rounded, onMenos),
        SizedBox(
          width: 32,
          child: Text('$valor',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        ),
        b(Icons.add_rounded, onMas),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const SectionTitle(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.dark)),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const SummaryRow(this.label, this.value, {super.key, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final s = TextStyle(
      fontSize: bold ? 17 : 14,
      fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
      color: bold ? AppColors.dark : AppColors.textMuted,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        Expanded(child: Text(label, style: s)),
        Text(value, style: s),
      ]),
    );
  }
}

/// Caja blanca con borde (no usar con ListTile: para eso, [Tarjeta]).
class Caja extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const Caja({super.key, required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

/// Superficie Material redondeada, apta para ListTile e InkWell.
class Tarjeta extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color borde;
  final VoidCallback? onTap;
  const Tarjeta({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.borde = AppColors.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: color,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: borde),
        ),
        child: onTap == null ? child : InkWell(onTap: onTap, child: child),
      ),
    );
  }
}

class Vacio extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String texto;
  const Vacio(
      {super.key, required this.icon, required this.titulo, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          Icon(icon, size: 64, color: AppColors.primarySoft),
          const SizedBox(height: 12),
          Text(titulo,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(texto,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
