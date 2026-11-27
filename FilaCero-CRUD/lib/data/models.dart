import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Modelos del CRUD en memoria de FilaCero.
enum Rol { estudiante, comedor }

class Usuario {
  final String id;
  String nombre;
  String correo;
  String password;
  final Rol rol;
  double saldo;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.password,
    required this.rol,
    this.saldo = 0,
  });

  String get inicial => nombre.isEmpty ? '?' : nombre[0].toUpperCase();
}

class Plato {
  final String id;
  String nombre;
  String descripcion;
  String categoria;
  double precio;
  int stock;
  bool disponible;
  Color color;
  IconData icon;

  Plato({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.precio,
    required this.stock,
    this.disponible = true,
    required this.color,
    required this.icon,
  });

  bool get sePuedePedir => disponible && stock > 0;
}

class ItemPedido {
  final Plato plato;
  int cantidad;
  /// Precio congelado al momento de pedir (si el comedor cambia el precio,
  /// los pedidos ya hechos no cambian).
  final double precio;
  ItemPedido(this.plato, this.cantidad, {double? precio})
      : precio = precio ?? plato.precio;
  double get subtotal => precio * cantidad;
  ItemPedido copia() => ItemPedido(plato, cantidad, precio: precio);
}

enum EstadoPedido { pendiente, enPreparacion, listo, entregado, rechazado }

extension EstadoPedidoX on EstadoPedido {
  String get label => switch (this) {
        EstadoPedido.pendiente => 'Pendiente',
        EstadoPedido.enPreparacion => 'En preparación',
        EstadoPedido.listo => 'Listo para retirar',
        EstadoPedido.entregado => 'Entregado',
        EstadoPedido.rechazado => 'Rechazado',
      };

  Color get color => switch (this) {
        EstadoPedido.pendiente => AppColors.warning,
        EstadoPedido.enPreparacion => AppColors.primary,
        EstadoPedido.listo => AppColors.success,
        EstadoPedido.entregado => AppColors.textMuted,
        EstadoPedido.rechazado => AppColors.danger,
      };

  IconData get icon => switch (this) {
        EstadoPedido.pendiente => Icons.schedule_rounded,
        EstadoPedido.enPreparacion => Icons.soup_kitchen_rounded,
        EstadoPedido.listo => Icons.check_circle_rounded,
        EstadoPedido.entregado => Icons.task_alt_rounded,
        EstadoPedido.rechazado => Icons.cancel_rounded,
      };

  /// Pedidos que todavía ocupan stock y están "en curso".
  bool get activo =>
      this == EstadoPedido.pendiente ||
      this == EstadoPedido.enPreparacion ||
      this == EstadoPedido.listo;
}

class Pedido {
  final String codigo;
  final String usuarioId;
  List<ItemPedido> items;
  DateTime retiro; // fecha y hora de retiro
  String metodoPago;
  bool paraLlevar;
  String nota;
  EstadoPedido estado;
  String? motivoRechazo;
  final DateTime creado;
  DateTime actualizado;

  Pedido({
    required this.codigo,
    required this.usuarioId,
    required this.items,
    required this.retiro,
    required this.metodoPago,
    required this.paraLlevar,
    required this.nota,
    this.estado = EstadoPedido.pendiente,
    required this.creado,
  }) : actualizado = creado;

  static const cargoTaper = 0.25;

  double get subtotal => items.fold(0, (s, i) => s + i.subtotal);
  double get total => subtotal + (paraLlevar ? cargoTaper : 0);
  int get unidades => items.fold(0, (s, i) => s + i.cantidad);
  String get resumen =>
      items.map((i) => '${i.plato.nombre} x${i.cantidad}').join(', ');
  bool get editable => estado == EstadoPedido.pendiente;
  bool get eliminable =>
      estado == EstadoPedido.pendiente || estado == EstadoPedido.rechazado;
}

class Notificacion {
  final String usuarioId;
  final String titulo;
  final String cuerpo;
  final DateTime fecha;
  final IconData icon;
  final Color color;
  bool leida;

  Notificacion({
    required this.usuarioId,
    required this.titulo,
    required this.cuerpo,
    required this.fecha,
    required this.icon,
    required this.color,
    this.leida = false,
  });
}

const categorias = ['Almuerzo', 'Snacks', 'Bebidas', 'Postres'];
const metodosPago = ['Saldo FilaCero', 'Tarjeta', 'Efectivo en ventanilla'];
const motivosRechazo = [
  'Se agotó un plato',
  'Fuera del horario de atención',
  'Pago no confirmado',
  'Pedido duplicado',
];

/// Íconos y colores para elegir en el formulario de platos.
const iconosPlato = <IconData>[
  Icons.rice_bowl_rounded,
  Icons.dinner_dining_rounded,
  Icons.eco_rounded,
  Icons.lunch_dining_rounded,
  Icons.bakery_dining_rounded,
  Icons.local_drink_rounded,
  Icons.coffee_rounded,
  Icons.cake_rounded,
  Icons.icecream_rounded,
  Icons.local_pizza_rounded,
];

const coloresPlato = <Color>[
  AppColors.orange,
  AppColors.green,
  AppColors.yellow,
  AppColors.pink,
  AppColors.blue,
];

String money(double v) => '\$${v.toStringAsFixed(2)}';

String two(int n) => n.toString().padLeft(2, '0');

String hora(DateTime d) => '${two(d.hour)}:${two(d.minute)}';

const _meses = [
  'ene', 'feb', 'mar', 'abr', 'may', 'jun',
  'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
];

String fechaCorta(DateTime d) {
  final hoy = DateTime.now();
  final dia = DateTime(d.year, d.month, d.day);
  final h = DateTime(hoy.year, hoy.month, hoy.day);
  final diff = dia.difference(h).inDays;
  if (diff == 0) return 'Hoy';
  if (diff == 1) return 'Mañana';
  if (diff == -1) return 'Ayer';
  return '${d.day} ${_meses[d.month - 1]}';
}
