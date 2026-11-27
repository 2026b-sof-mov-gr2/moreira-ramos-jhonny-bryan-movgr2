import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fila_cero_crud/data/app_store.dart';
import 'package:fila_cero_crud/data/models.dart';
import 'package:fila_cero_crud/main.dart';

/// Pruebas de las reglas del CRUD en memoria.
void main() {
  // Viernes 27/11/2026 a las 11:40.
  final ahora = DateTime(2026, 11, 27, 11, 40);
  DateTime a(int h, int m, {int dias = 0}) =>
      DateTime(2026, 11, 27 + dias, h, m);

  setUp(() {
    store.reloj = () => ahora;
    store.reiniciar();
    expect(store.login('jhonny.moreira@epn.edu.ec', 'filacero123'), isNull);
  });

  Plato plato(String n) => store.platos.firstWhere((p) => p.nombre == n);

  Resultado<Pedido> crear(List<ItemPedido> items,
          {DateTime? retiro, String? metodo, bool llevar = false}) =>
      store.crearPedido(
        items: items,
        retiro: retiro ?? a(12, 30),
        metodoPago: metodo ?? metodosPago.first,
        paraLlevar: llevar,
        nota: '',
      );

  group('Usuarios', () {
    test('login valida correo y contraseña', () {
      store.logout();
      expect(store.login('', ''), isNotNull);
      expect(store.login('nadie@epn.edu.ec', 'x'), contains('No existe'));
      expect(store.login('comedor@epn.edu.ec', 'mala'), contains('incorrecta'));
      expect(store.login('comedor@epn.edu.ec', 'comedor123'), isNull);
      expect(store.esComedor, isTrue);
    });

    test('registro valida correo EPN, longitud y duplicados', () {
      String? reg(String c, String p, String p2) => store.registrar(
          nombre: 'Ana Pérez', correo: c, password: p, confirmar: p2);
      expect(reg('ana@gmail.com', '12345678', '12345678'), contains('@epn'));
      expect(reg('ana@epn.edu.ec', '123', '123'), contains('8'));
      expect(reg('ana@epn.edu.ec', '12345678', '1234567x'),
          contains('no coinciden'));
      expect(reg('jhonny.moreira@epn.edu.ec', '12345678', '12345678'),
          contains('Ya existe'));
      expect(reg('ana@epn.edu.ec', '12345678', '12345678'), isNull);
      expect(store.actual!.nombre, 'Ana Pérez');
    });
  });

  group('Pedidos (CRUD)', () {
    test('crear descuenta stock y saldo y genera notificación', () {
      final almuerzo = plato('Almuerzo del día');
      final r = crear([ItemPedido(almuerzo, 2)]);
      expect(r.ok, isTrue);
      expect(r.valor!.codigo, 'A-27');
      expect(almuerzo.stock, 38);
      expect(store.actual!.saldo, closeTo(12.50 - 5.00, 1e-9));
      expect(store.misNotificaciones.first.titulo, contains('A-27'));
    });

    test('validaciones al crear', () {
      expect(crear([]).error, contains('al menos un plato'));
      expect(crear([ItemPedido(plato('Seco de pollo'), 1)]).error,
          contains('agotado'));
      expect(crear([ItemPedido(plato('Jugo natural'), 6)]).error,
          contains('Máximo 5'));
      expect(crear([ItemPedido(plato('Jugo natural'), 1)], retiro: a(16, 0))
          .error, contains('entre 11:00 y 15:00'));
      expect(crear([ItemPedido(plato('Jugo natural'), 1)], retiro: a(11, 45))
          .error, contains('10 minutos'));
      expect(
          crear([ItemPedido(plato('Jugo natural'), 1)],
                  retiro: a(12, 0, dias: -1))
              .error,
          contains('pasada'));
      expect(
          crear([ItemPedido(plato('Jugo natural'), 1)],
                  retiro: a(12, 0, dias: 2))
              .error,
          contains('domingos'));
      expect(
          crear([ItemPedido(plato('Menú vegetariano'), 5)]).error,
          contains('Saldo insuficiente'));
      plato('Café pasado').disponible = false;
      expect(crear([ItemPedido(plato('Café pasado'), 1)]).error,
          contains('no está disponible'));
    });

    test('máximo 2 pedidos en curso', () {
      final jugo = plato('Jugo natural');
      expect(crear([ItemPedido(jugo, 1)]).ok, isTrue);
      expect(crear([ItemPedido(jugo, 1)]).ok, isTrue);
      expect(crear([ItemPedido(jugo, 1)]).error, contains('2 pedidos'));
    });

    test('editar solo si está pendiente y reajusta stock y saldo', () {
      final jugo = plato('Jugo natural');
      final p = crear([ItemPedido(jugo, 2)]).valor!;
      expect(jugo.stock, 48);
      final e = store.actualizarPedido(p,
          items: [ItemPedido(jugo, 4)],
          retiro: a(13, 0),
          metodoPago: metodosPago.first,
          paraLlevar: true,
          nota: 'sin hielo');
      expect(e, isNull);
      expect(jugo.stock, 46);
      expect(p.total, closeTo(3.25, 1e-9));
      expect(store.actual!.saldo, closeTo(12.50 - 3.25, 1e-9));
      store.avanzarEstado(p); // en preparación
      expect(
          store.actualizarPedido(p,
              items: [ItemPedido(jugo, 1)],
              retiro: a(13, 0),
              metodoPago: metodosPago.first,
              paraLlevar: false,
              nota: ''),
          contains('Solo puedes editar'));
    });

    test('eliminar devuelve stock y saldo; no se elimina si está en curso', () {
      final jugo = plato('Jugo natural');
      final p = crear([ItemPedido(jugo, 2)]).valor!;
      expect(store.eliminarPedido(p), isNull);
      expect(jugo.stock, 50);
      expect(store.actual!.saldo, closeTo(12.50, 1e-9));
      final q = crear([ItemPedido(jugo, 1)]).valor!;
      store.avanzarEstado(q);
      expect(store.eliminarPedido(q), contains('No puedes eliminar'));
    });

    test('el comedor rechaza con motivo y se devuelve el saldo', () {
      final jugo = plato('Jugo natural');
      final p = crear([ItemPedido(jugo, 2)]).valor!;
      expect(store.rechazarPedido(p, motivosRechazo.first), isNull);
      expect(p.estado, EstadoPedido.rechazado);
      expect(jugo.stock, 50);
      expect(store.actual!.saldo, closeTo(12.50, 1e-9));
      expect(store.eliminarPedido(p), isNull); // rechazado sí se elimina
    });

    test('flujo de estados hasta entregado', () {
      final p = crear([ItemPedido(plato('Jugo natural'), 1)]).valor!;
      store.avanzarEstado(p);
      store.avanzarEstado(p);
      store.avanzarEstado(p);
      expect(p.estado, EstadoPedido.entregado);
      expect(store.avanzarEstado(p), isNotNull);
    });
  });

  group('Platos (CRUD)', () {
    String? guardar(String n, {double? precio = 1, int? stock = 5, Plato? ex}) =>
        store.guardarPlato(
          existente: ex,
          nombre: n,
          descripcion: 'Rico',
          categoria: 'Snacks',
          precio: precio,
          stock: stock,
          disponible: true,
          color: coloresPlato.first,
          icon: iconosPlato.first,
        );

    test('crear, validar, editar y eliminar', () {
      final n = store.platos.length;
      expect(guardar('Pa'), contains('3 letras'));
      expect(guardar('jugo natural'), contains('Ya existe'));
      expect(guardar('Humita', precio: 0), contains('precio'));
      expect(guardar('Humita', stock: -5), contains('stock'));
      expect(guardar('Humita'), isNull);
      expect(store.platos.length, n + 1);
      final h = plato('Humita');
      expect(guardar('Humita de sal', precio: 1.25, ex: h), isNull);
      expect(h.nombre, 'Humita de sal');
      expect(store.eliminarPlato(h), isNull);
      expect(store.platos.length, n);
    });

    test('no se elimina un plato con pedidos activos', () {
      final jugo = plato('Jugo natural');
      crear([ItemPedido(jugo, 1)]);
      expect(store.eliminarPlato(jugo), contains('pedidos activos'));
    });
  });

  testWidgets('La app abre el login y entra como estudiante', (t) async {
    store.logout();
    t.view.physicalSize = const Size(1080, 2400);
    t.view.devicePixelRatio = 2.6;
    addTearDown(t.view.reset);
    await t.pumpWidget(const FilaCeroCrudApp());
    await t.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsOneWidget);
    await t.tap(find.text('Estudiante'));
    await t.tap(find.text('Iniciar sesión'));
    await t.pumpAndSettle();
    expect(find.text('Comedor EPN'), findsOneWidget);
    await t.tap(find.byIcon(Icons.receipt_long_outlined));
    await t.pumpAndSettle();
    await t.tap(find.byIcon(Icons.person_outline_rounded));
    await t.pumpAndSettle();
    expect(find.text('Cerrar sesión').hitTestable(), findsOneWidget);
  });

  testWidgets('El comedor ve pedidos y platos', (t) async {
    crear([ItemPedido(plato('Jugo natural'), 1)]);
    store.logout();
    t.view.physicalSize = const Size(1080, 2400);
    t.view.devicePixelRatio = 2.6;
    addTearDown(t.view.reset);
    await t.pumpWidget(const FilaCeroCrudApp());
    await t.pumpAndSettle();
    await t.tap(find.text('Comedor'));
    await t.tap(find.text('Iniciar sesión'));
    await t.pumpAndSettle();
    expect(find.text('Preparar'), findsOneWidget);
    await t.tap(find.byIcon(Icons.restaurant_outlined));
    await t.pumpAndSettle();
    expect(find.text('Nuevo plato'), findsOneWidget);
    await t.pump(const Duration(seconds: 4)); // espera a que se cierre el toast
    await t.pumpAndSettle();
    await t.tap(find.text('Nuevo plato'));
    await t.pumpAndSettle();
    expect(find.text('Crear plato'), findsOneWidget);
  });
}
