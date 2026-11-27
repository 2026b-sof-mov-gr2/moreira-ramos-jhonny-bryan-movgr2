import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';
import 'order_detail_screen.dart';

/// Formulario para CREAR un pedido (desde el carrito) o EDITAR uno pendiente.
class OrderFormScreen extends StatefulWidget {
  final Pedido? pedido;
  const OrderFormScreen({super.key, this.pedido});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  late List<ItemPedido> _items;
  late DateTime _retiro;
  late String _metodo;
  late bool _llevar;
  late final TextEditingController _nota;

  bool get _editando => widget.pedido != null;

  @override
  void initState() {
    super.initState();
    final p = widget.pedido;
    _items = (p?.items ?? store.carrito).map((i) => i.copia()).toList();
    _retiro = p?.retiro ?? store.sugerirRetiro();
    _metodo = p?.metodoPago ?? metodosPago.first;
    _llevar = p?.paraLlevar ?? false;
    _nota = TextEditingController(text: p?.nota ?? '');
  }

  @override
  void dispose() {
    _nota.dispose();
    super.dispose();
  }

  double get _total =>
      _items.fold<double>(0, (s, i) => s + i.subtotal) +
      (_llevar ? Pedido.cargoTaper : 0);

  Future<void> _elegirFecha() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _retiro.isBefore(now) ? now : _retiro,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: AppStore.diasAnticipacion + 7)),
      helpText: 'Fecha de retiro',
    );
    if (d != null) {
      setState(() => _retiro =
          DateTime(d.year, d.month, d.day, _retiro.hour, _retiro.minute));
    }
  }

  Future<void> _elegirHora() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_retiro),
      helpText: 'Hora de retiro (11:00 – 15:00)',
    );
    if (t != null) {
      setState(() => _retiro = DateTime(
          _retiro.year, _retiro.month, _retiro.day, t.hour, t.minute));
    }
  }

  Future<void> _agregarPlato() async {
    final elegido = await showModalBottomSheet<Plato>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            const Text('Agregar plato',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            ...store.platos.map((p) => ListTile(
                  enabled: p.sePuedePedir,
                  leading: PlatoThumb(plato: p, size: 40),
                  title: Text(p.nombre),
                  subtitle: Text(p.sePuedePedir
                      ? '${money(p.precio)} · ${p.stock} disponibles'
                      : 'Agotado'),
                  onTap: () => Navigator.pop(ctx, p),
                )),
          ],
        ),
      ),
    );
    if (elegido == null) return;
    setState(() {
      final it = _items.where((i) => i.plato.id == elegido.id).firstOrNull;
      if (it == null) {
        _items.add(ItemPedido(elegido, 1));
      } else {
        it.cantidad++;
      }
    });
  }

  void _guardar() {
    FocusScope.of(context).unfocus();
    if (_editando) {
      final e = store.actualizarPedido(
        widget.pedido!,
        items: _items,
        retiro: _retiro,
        metodoPago: _metodo,
        paraLlevar: _llevar,
        nota: _nota.text,
      );
      if (e != null) {
        toast(context, e, error: true);
        return;
      }
      toast(context, 'Pedido #${widget.pedido!.codigo} actualizado');
      Navigator.pop(context);
    } else {
      final r = store.crearPedido(
        items: _items,
        retiro: _retiro,
        metodoPago: _metodo,
        paraLlevar: _llevar,
        nota: _nota.text,
      );
      if (!r.ok) {
        toast(context, r.error!, error: true);
        return;
      }
      store.vaciarCarrito();
      toast(context, 'Pedido #${r.valor!.codigo} creado');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OrderDetailScreen(pedido: r.valor!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final saldo = store.actual?.saldo ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando
            ? 'Editar pedido #${widget.pedido!.codigo}'
            : 'Nuevo pedido'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          SectionTitle('Platos',
              trailing: TextButton.icon(
                onPressed: _agregarPlato,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Agregar'),
              )),
          if (_items.isEmpty)
            const Caja(
              child: Text('Tu pedido está vacío. Agrega al menos un plato.',
                  style: TextStyle(color: AppColors.textMuted)),
            ),
          ..._items.map((it) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Caja(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      PlatoThumb(plato: it.plato, size: 46),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(it.plato.nombre,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                            Text(money(it.subtotal),
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      Cantidad(
                        valor: it.cantidad,
                        onMenos: () => setState(() {
                          it.cantidad--;
                          if (it.cantidad <= 0) _items.remove(it);
                        }),
                        onMas: () => setState(() => it.cantidad++),
                      ),
                    ],
                  ),
                ),
              )),
          const SectionTitle('Retiro'),
          Row(
            children: [
              Expanded(
                child: _Selector(
                  icon: Icons.calendar_month_rounded,
                  label: 'Fecha',
                  valor:
                      '${fechaCorta(_retiro)} ${_retiro.day}/${_retiro.month}',
                  onTap: _elegirFecha,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Selector(
                  icon: Icons.schedule_rounded,
                  label: 'Hora',
                  valor: hora(_retiro),
                  onTap: _elegirHora,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Horario de retiro: 11:00 a 15:00, de lunes a sábado.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SectionTitle('Método de pago'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: metodosPago
                .map((m) => ChoiceChip(
                      label: Text(m == metodosPago.first
                          ? '$m (${money(saldo)})'
                          : m),
                      selected: _metodo == m,
                      onSelected: (_) => setState(() => _metodo = m),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Tarjeta(
            child: SwitchListTile(
              value: _llevar,
              onChanged: (v) => setState(() => _llevar = v),
              title: const Text('Para llevar (táper)'),
              subtitle: Text('+${money(Pedido.cargoTaper)}'),
            ),
          ),
          TextField(
            controller: _nota,
            maxLength: 100,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Nota para cocina (opcional)',
              hintText: 'Ej. sin cebolla',
            ),
          ),
          const SizedBox(height: 8),
          Caja(
            child: Column(
              children: [
                SummaryRow('Subtotal',
                    money(_items.fold<double>(0, (s, i) => s + i.subtotal))),
                if (_llevar)
                  SummaryRow('Táper', money(Pedido.cargoTaper)),
                const Divider(height: 20),
                SummaryRow('Total', money(_total), bold: true),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton.icon(
            onPressed: _guardar,
            icon: Icon(_editando ? Icons.save_rounded : Icons.check_rounded),
            label: Text(_editando
                ? 'Guardar cambios · ${money(_total)}'
                : 'Confirmar pedido · ${money(_total)}'),
          ),
        ),
      ),
    );
  }
}

class _Selector extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;
  final VoidCallback onTap;
  const _Selector(
      {required this.icon,
      required this.label,
      required this.valor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tarjeta(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted)),
                  Text(valor,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 15)),
                ],
              ),
            ),
            const Icon(Icons.edit_rounded, size: 16, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
