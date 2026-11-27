import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'models.dart';

/// Resultado de una operación del CRUD: [error] es null si salió bien.
class Resultado<T> {
  final T? valor;
  final String? error;
  const Resultado.ok(this.valor) : error = null;
  const Resultado.fallo(this.error) : valor = null;
  bool get ok => error == null;
}

/// "Base de datos" en memoria: listas de Dart que viven mientras la app
/// está abierta. Notifica a la UI con ChangeNotifier en cada cambio.
class AppStore extends ChangeNotifier {
  AppStore._() {
    _seed();
  }

  static final AppStore instance = AppStore._();

  /// Para pruebas: vuelve a los datos iniciales.
  void reiniciar() {
    usuarios.clear();
    platos.clear();
    pedidos.clear();
    notificaciones.clear();
    carrito.clear();
    actual = null;
    _seq = 26;
    _seed();
    notifyListeners();
  }

  // ---------------------------------------------------------------- datos
  final List<Usuario> usuarios = [];
  final List<Plato> platos = [];
  final List<Pedido> pedidos = [];
  final List<Notificacion> notificaciones = [];
  Usuario? actual;
  int _seq = 26;

  // Reglas de negocio
  static const horaApertura = 11; // 11:00
  static const horaCierre = 15; // 15:00
  static const maxPorPlato = 5;
  static const maxPedidosActivos = 2;
  static const minutosPreparacion = 10;
  static const diasAnticipacion = 6;

  /// Reloj inyectable (para las pruebas).
  DateTime Function() reloj = DateTime.now;

  void _seed() {
    usuarios.addAll([
      Usuario(
        id: 'u1',
        nombre: 'Jhonny Moreira',
        correo: 'jhonny.moreira@epn.edu.ec',
        password: 'filacero123',
        rol: Rol.estudiante,
        saldo: 12.50,
      ),
      Usuario(
        id: 'u2',
        nombre: 'Comedor EPN',
        correo: 'comedor@epn.edu.ec',
        password: 'comedor123',
        rol: Rol.comedor,
      ),
    ]);
    var i = 0;
    Plato p(String n, String d, String c, double pr, int st, Color co,
            IconData ic, {bool disp = true}) =>
        Plato(
          id: 'p${++i}',
          nombre: n,
          descripcion: d,
          categoria: c,
          precio: pr,
          stock: st,
          color: co,
          icon: ic,
          disponible: disp,
        );
    platos.addAll([
      p('Almuerzo del día', 'Sopa, arroz, pollo y jugo', 'Almuerzo', 2.50, 40,
          AppColors.orange, Icons.rice_bowl_rounded),
      p('Menú vegetariano', 'Crema de zapallo, menestra y ensalada',
          'Almuerzo', 2.75, 15, AppColors.green, Icons.eco_rounded),
      p('Seco de pollo', 'Arroz, maduro y ensalada', 'Almuerzo', 3.00, 0,
          AppColors.pink, Icons.dinner_dining_rounded),
      p('Sánduche de pollo', 'Pan, pollo, lechuga y salsa', 'Snacks', 1.75,
          20, AppColors.green, Icons.lunch_dining_rounded),
      p('Empanada de queso', 'Recién horneada', 'Snacks', 0.80, 30,
          AppColors.yellow, Icons.bakery_dining_rounded),
      p('Jugo natural', 'Mora, naranja o maracuyá', 'Bebidas', 0.75, 50,
          AppColors.yellow, Icons.local_drink_rounded),
      p('Café pasado', 'Con o sin leche', 'Bebidas', 0.60, 25,
          AppColors.orange, Icons.coffee_rounded),
      p('Torta de chocolate', 'Porción individual', 'Postres', 1.25, 10,
          AppColors.pink, Icons.cake_rounded),
    ]);

    // Un pedido ya entregado de días anteriores para que el historial no
    // esté vacío.
    final ayer = reloj().subtract(const Duration(days: 1));
    pedidos.add(Pedido(
      codigo: 'A-26',
      usuarioId: 'u1',
      items: [ItemPedido(platos[3], 1), ItemPedido(platos[6], 1)],
      retiro: DateTime(ayer.year, ayer.month, ayer.day, 13, 10),
      metodoPago: metodosPago[0],
      paraLlevar: false,
      nota: '',
      estado: EstadoPedido.entregado,
      creado: DateTime(ayer.year, ayer.month, ayer.day, 12, 50),
    ));
  }

  // ------------------------------------------------------------- usuarios
  bool get esComedor => actual?.rol == Rol.comedor;

  String? login(String correo, String password) {
    final c = correo.trim().toLowerCase();
    if (c.isEmpty || password.isEmpty) {
      return 'Ingresa tu correo y contraseña';
    }
    final u = usuarios.where((u) => u.correo == c).firstOrNull;
    if (u == null) return 'No existe una cuenta con ese correo';
    if (u.password != password) return 'Contraseña incorrecta';
    actual = u;
    notifyListeners();
    return null;
  }

  String? registrar({
    required String nombre,
    required String correo,
    required String password,
    required String confirmar,
  }) {
    final n = nombre.trim();
    final c = correo.trim().toLowerCase();
    if (n.length < 3) return 'Escribe tu nombre completo';
    if (!RegExp(r'^[\w.\-]+@epn\.edu\.ec$').hasMatch(c)) {
      return 'Usa tu correo institucional @epn.edu.ec';
    }
    if (usuarios.any((u) => u.correo == c)) {
      return 'Ya existe una cuenta con ese correo';
    }
    if (password.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    if (password != confirmar) return 'Las contraseñas no coinciden';
    final u = Usuario(
      id: 'u${usuarios.length + 1}',
      nombre: n,
      correo: c,
      password: password,
      rol: Rol.estudiante,
      saldo: 10,
    );
    usuarios.add(u);
    actual = u;
    notifyListeners();
    return null;
  }

  void logout() {
    actual = null;
    carrito.clear();
    notifyListeners();
  }

  // ---------------------------------------------------- CRUD de platos
  String? guardarPlato({
    Plato? existente,
    required String nombre,
    required String descripcion,
    required String categoria,
    required double? precio,
    required int? stock,
    required bool disponible,
    required Color color,
    required IconData icon,
  }) {
    final n = nombre.trim();
    if (n.length < 3) return 'El nombre debe tener al menos 3 letras';
    final repetido = platos.any((p) =>
        p.id != existente?.id && p.nombre.toLowerCase() == n.toLowerCase());
    if (repetido) return 'Ya existe un plato llamado "$n"';
    if (descripcion.trim().isEmpty) return 'Escribe una descripción';
    if (precio == null || precio < 0.25 || precio > 20) {
      return 'El precio debe estar entre \$0.25 y \$20.00';
    }
    if (stock == null || stock < 0 || stock > 200) {
      return 'El stock debe estar entre 0 y 200';
    }
    if (existente == null) {
      platos.add(Plato(
        id: 'p${DateTime.now().microsecondsSinceEpoch}',
        nombre: n,
        descripcion: descripcion.trim(),
        categoria: categoria,
        precio: precio,
        stock: stock,
        disponible: disponible,
        color: color,
        icon: icon,
      ));
    } else {
      existente
        ..nombre = n
        ..descripcion = descripcion.trim()
        ..categoria = categoria
        ..precio = precio
        ..stock = stock
        ..disponible = disponible
        ..color = color
        ..icon = icon;
    }
    notifyListeners();
    return null;
  }

  String? eliminarPlato(Plato p) {
    final enUso = pedidos.any(
        (o) => o.estado.activo && o.items.any((i) => i.plato.id == p.id));
    if (enUso) {
      return 'No se puede eliminar: hay pedidos activos con "${p.nombre}"';
    }
    platos.remove(p);
    notifyListeners();
    return null;
  }

  void cambiarDisponible(Plato p, bool v) {
    p.disponible = v;
    notifyListeners();
  }

  // --------------------------------------------------- CRUD de pedidos
  List<Pedido> get misPedidos =>
      pedidos.where((p) => p.usuarioId == actual?.id).toList()
        ..sort((a, b) => b.creado.compareTo(a.creado));

  List<Pedido> pedidosPorEstado(EstadoPedido? e) =>
      pedidos.where((p) => e == null || p.estado == e).toList()
        ..sort((a, b) => a.retiro.compareTo(b.retiro));

  Usuario? usuario(String id) =>
      usuarios.where((u) => u.id == id).firstOrNull;

  /// Primera hora válida para sugerir en un pedido nuevo.
  DateTime sugerirRetiro() {
    final now = reloj();
    var d = DateTime(now.year, now.month, now.day, 12, 30);
    final minimo = now.add(const Duration(minutes: minutosPreparacion + 5));
    if (d.isBefore(minimo)) {
      d = DateTime(now.year, now.month, now.day, minimo.hour,
          (minimo.minute ~/ 5 + 1) * 5);
    }
    if (d.hour >= horaCierre) {
      d = DateTime(now.year, now.month, now.day + 1, 12, 30);
    }
    while (d.weekday == DateTime.sunday) {
      d = d.add(const Duration(days: 1));
    }
    return d;
  }

  /// Aplica todas las reglas de negocio de un pedido.
  String? validarPedido({
    required List<ItemPedido> items,
    required DateTime retiro,
    required String metodoPago,
    required bool paraLlevar,
    required String nota,
    Pedido? editando,
  }) {
    final u = actual;
    if (u == null) return 'Inicia sesión para pedir';
    final validos = items.where((i) => i.cantidad > 0).toList();
    if (validos.isEmpty) return 'Agrega al menos un plato a tu pedido';

    for (final i in validos) {
      final p = i.plato;
      if (!platos.contains(p)) return '"${p.nombre}" ya no está en el menú';
      if (!p.disponible) return '"${p.nombre}" no está disponible hoy';
      if (i.cantidad > maxPorPlato) {
        return 'Máximo $maxPorPlato unidades de "${p.nombre}" por pedido';
      }
      final reservado = editando?.items
              .where((x) => x.plato.id == p.id)
              .fold<int>(0, (s, x) => s + x.cantidad) ??
          0;
      if (i.cantidad > p.stock + reservado) {
        final quedan = p.stock + reservado;
        return quedan == 0
            ? '"${p.nombre}" está agotado'
            : 'Solo quedan $quedan de "${p.nombre}"';
      }
    }

    final now = reloj();
    final hoy = DateTime(now.year, now.month, now.day);
    final dia = DateTime(retiro.year, retiro.month, retiro.day);
    if (dia.isBefore(hoy)) return 'La fecha de retiro no puede ser pasada';
    if (dia.difference(hoy).inDays > diasAnticipacion) {
      return 'Solo puedes pedir con hasta $diasAnticipacion días de anticipación';
    }
    if (retiro.weekday == DateTime.sunday) {
      return 'El comedor no atiende los domingos';
    }
    final minutos = retiro.hour * 60 + retiro.minute;
    if (minutos < horaApertura * 60 || minutos > horaCierre * 60) {
      return 'El retiro debe ser entre ${two(horaApertura)}:00 y '
          '${two(horaCierre)}:00';
    }
    if (retiro.isBefore(now.add(const Duration(minutes: minutosPreparacion)))) {
      return 'Elige una hora al menos $minutosPreparacion minutos después de '
          'ahora (${hora(now)})';
    }

    if (editando == null) {
      final activos = pedidos
          .where((p) => p.usuarioId == u.id && p.estado.activo)
          .length;
      if (activos >= maxPedidosActivos) {
        return 'Ya tienes $maxPedidosActivos pedidos en curso; espera a '
            'retirarlos';
      }
    }

    if (nota.length > 100) return 'La nota puede tener hasta 100 caracteres';

    if (metodoPago == metodosPago[0]) {
      final total = validos.fold<double>(0, (s, i) => s + i.subtotal) +
          (paraLlevar ? Pedido.cargoTaper : 0);
      final devuelto = editando != null && editando.metodoPago == metodosPago[0]
          ? editando.total
          : 0;
      if (total > u.saldo + devuelto + 1e-9) {
        return 'Saldo insuficiente: tienes ${money(u.saldo + devuelto)} y el '
            'pedido cuesta ${money(total)}';
      }
    }
    return null;
  }

  Resultado<Pedido> crearPedido({
    required List<ItemPedido> items,
    required DateTime retiro,
    required String metodoPago,
    required bool paraLlevar,
    required String nota,
  }) {
    final error = validarPedido(
      items: items,
      retiro: retiro,
      metodoPago: metodoPago,
      paraLlevar: paraLlevar,
      nota: nota,
    );
    if (error != null) return Resultado.fallo(error);
    final limpios = items.where((i) => i.cantidad > 0).map((i) => i.copia());
    final p = Pedido(
      codigo: 'A-${++_seq}',
      usuarioId: actual!.id,
      items: limpios.toList(),
      retiro: retiro,
      metodoPago: metodoPago,
      paraLlevar: paraLlevar,
      nota: nota.trim(),
      creado: reloj(),
    );
    _reservar(p);
    pedidos.add(p);
    _notificar(
      p.usuarioId,
      'Pedido #${p.codigo} recibido',
      'Retiro ${fechaCorta(p.retiro).toLowerCase()} a las ${hora(p.retiro)}. '
          'Total ${money(p.total)}.',
      Icons.receipt_long_rounded,
      AppColors.primary,
    );
    notifyListeners();
    return Resultado.ok(p);
  }

  String? actualizarPedido(
    Pedido p, {
    required List<ItemPedido> items,
    required DateTime retiro,
    required String metodoPago,
    required bool paraLlevar,
    required String nota,
  }) {
    if (!p.editable) {
      return 'Solo puedes editar pedidos pendientes; este está '
          '"${p.estado.label.toLowerCase()}"';
    }
    final error = validarPedido(
      items: items,
      retiro: retiro,
      metodoPago: metodoPago,
      paraLlevar: paraLlevar,
      nota: nota,
      editando: p,
    );
    if (error != null) return error;
    _liberar(p);
    p
      ..items = items.where((i) => i.cantidad > 0).map((i) => i.copia()).toList()
      ..retiro = retiro
      ..metodoPago = metodoPago
      ..paraLlevar = paraLlevar
      ..nota = nota.trim()
      ..actualizado = reloj();
    _reservar(p);
    notifyListeners();
    return null;
  }

  String? eliminarPedido(Pedido p) {
    if (!p.eliminable) {
      return 'No puedes eliminar un pedido "${p.estado.label.toLowerCase()}"';
    }
    if (p.estado == EstadoPedido.pendiente) _liberar(p);
    pedidos.remove(p);
    notifyListeners();
    return null;
  }

  // ------------------------------------------- gestión del comedor
  static const _flujo = [
    EstadoPedido.pendiente,
    EstadoPedido.enPreparacion,
    EstadoPedido.listo,
    EstadoPedido.entregado,
  ];

  EstadoPedido? siguienteEstado(Pedido p) {
    final i = _flujo.indexOf(p.estado);
    if (i < 0 || i == _flujo.length - 1) return null;
    return _flujo[i + 1];
  }

  String? avanzarEstado(Pedido p) {
    final sig = siguienteEstado(p);
    if (sig == null) return 'Este pedido ya no puede avanzar';
    p
      ..estado = sig
      ..actualizado = reloj();
    final (titulo, cuerpo) = switch (sig) {
      EstadoPedido.enPreparacion => (
          'Tu pedido #${p.codigo} está en preparación',
          'Te avisaremos cuando esté listo.'
        ),
      EstadoPedido.listo => (
          'Tu pedido #${p.codigo} está listo',
          'Acércate a la ventanilla 2 con tu código QR.'
        ),
      _ => (
          'Pedido #${p.codigo} entregado',
          '¡Buen provecho! Califica tu experiencia.'
        ),
    };
    _notificar(p.usuarioId, titulo, cuerpo, sig.icon, sig.color);
    notifyListeners();
    return null;
  }

  String? rechazarPedido(Pedido p, String motivo) {
    if (p.estado != EstadoPedido.pendiente) {
      return 'Solo se pueden rechazar pedidos pendientes';
    }
    if (motivo.trim().isEmpty) return 'Elige un motivo';
    _liberar(p);
    p
      ..estado = EstadoPedido.rechazado
      ..motivoRechazo = motivo
      ..actualizado = reloj();
    _notificar(
      p.usuarioId,
      'Tu pedido #${p.codigo} fue rechazado',
      'Motivo: $motivo. Se devolvió tu saldo.',
      Icons.cancel_rounded,
      AppColors.danger,
    );
    notifyListeners();
    return null;
  }

  // ------------------------------------------------------------ carrito
  /// Borrador del próximo pedido (todavía no es un pedido).
  final List<ItemPedido> carrito = [];

  int get unidadesCarrito => carrito.fold(0, (s, i) => s + i.cantidad);

  String? agregarAlCarrito(Plato p) {
    if (!p.disponible) return '"${p.nombre}" no está disponible';
    if (p.stock <= 0) return '"${p.nombre}" está agotado';
    final item = carrito.where((i) => i.plato.id == p.id).firstOrNull;
    final actualCant = item?.cantidad ?? 0;
    if (actualCant >= maxPorPlato) {
      return 'Máximo $maxPorPlato unidades de "${p.nombre}"';
    }
    if (actualCant >= p.stock) return 'Solo quedan ${p.stock} de "${p.nombre}"';
    if (item == null) {
      carrito.add(ItemPedido(p, 1));
    } else {
      item.cantidad++;
    }
    notifyListeners();
    return null;
  }

  void vaciarCarrito() {
    carrito.clear();
    notifyListeners();
  }

  // --------------------------------------------------- notificaciones
  List<Notificacion> get misNotificaciones =>
      notificaciones.where((n) => n.usuarioId == actual?.id).toList()
        ..sort((a, b) => b.fecha.compareTo(a.fecha));

  int get noLeidas => misNotificaciones.where((n) => !n.leida).length;

  void marcarLeidas() {
    for (final n in misNotificaciones) {
      n.leida = true;
    }
    notifyListeners();
  }

  // ---------------------------------------------------------- privados
  void _reservar(Pedido p) {
    for (final i in p.items) {
      i.plato.stock -= i.cantidad;
    }
    if (p.metodoPago == metodosPago[0]) {
      usuario(p.usuarioId)?.saldo -= p.total;
    }
  }

  void _liberar(Pedido p) {
    for (final i in p.items) {
      i.plato.stock += i.cantidad;
    }
    if (p.metodoPago == metodosPago[0]) {
      usuario(p.usuarioId)?.saldo += p.total;
    }
  }

  void _notificar(String uid, String t, String c, IconData i, Color col) {
    notificaciones.add(Notificacion(
      usuarioId: uid,
      titulo: t,
      cuerpo: c,
      fecha: reloj(),
      icon: i,
      color: col,
    ));
  }
}

final store = AppStore.instance;
