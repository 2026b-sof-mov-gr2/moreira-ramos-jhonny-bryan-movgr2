import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';

/// Platos típicos para llenar el formulario con un toque.
const _frecuentes = [
  ('Humita', 'Al vapor, con queso', 'Snacks', 1.00, Icons.bakery_dining_rounded, AppColors.yellow),
  ('Bolón de verde', 'Con queso o chicharrón', 'Snacks', 1.50, Icons.lunch_dining_rounded, AppColors.green),
  ('Encebollado', 'Con chifles y limón', 'Almuerzo', 3.00, Icons.rice_bowl_rounded, AppColors.orange),
  ('Morocho', 'Bebida de maíz con canela', 'Bebidas', 0.75, Icons.coffee_rounded, AppColors.pink),
];

/// Crear o editar un plato del menú.
class DishFormScreen extends StatefulWidget {
  final Plato? plato;
  const DishFormScreen({super.key, this.plato});

  @override
  State<DishFormScreen> createState() => _DishFormScreenState();
}

class _DishFormScreenState extends State<DishFormScreen> {
  late final _nombre = TextEditingController(text: widget.plato?.nombre);
  late final _desc = TextEditingController(text: widget.plato?.descripcion);
  late String _cat = widget.plato?.categoria ?? categorias.first;
  late double _precio = widget.plato?.precio ?? 1.00;
  late int _stock = widget.plato?.stock ?? 10;
  late bool _disp = widget.plato?.disponible ?? true;
  late Color _color = widget.plato?.color ?? coloresPlato.first;
  late IconData _icon = widget.plato?.icon ?? iconosPlato.first;

  bool get _editando => widget.plato != null;

  @override
  void dispose() {
    _nombre.dispose();
    _desc.dispose();
    super.dispose();
  }

  void _guardar() {
    FocusScope.of(context).unfocus();
    final e = store.guardarPlato(
      existente: widget.plato,
      nombre: _nombre.text,
      descripcion: _desc.text,
      categoria: _cat,
      precio: _precio,
      stock: _stock,
      disponible: _disp,
      color: _color,
      icon: _icon,
    );
    if (e != null) {
      toast(context, e, error: true);
      return;
    }
    toast(context,
        _editando ? 'Plato actualizado' : '"${_nombre.text.trim()}" creado');
    Navigator.pop(context);
  }

  Widget _paso(String label, String valor, VoidCallback menos, VoidCallback mas) {
    return Caja(
      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted)),
                Text(valor,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          IconButton.outlined(
              onPressed: menos, icon: const Icon(Icons.remove_rounded)),
          IconButton.filled(
              onPressed: mas, icon: const Icon(Icons.add_rounded)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vista = Plato(
      id: 'x',
      nombre: _nombre.text,
      descripcion: '',
      categoria: _cat,
      precio: _precio,
      stock: _stock,
      disponible: _disp,
      color: _color,
      icon: _icon,
    );
    return Scaffold(
      appBar: AppBar(title: Text(_editando ? 'Editar plato' : 'Nuevo plato')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Center(child: PlatoThumb(plato: vista, size: 84)),
          const SizedBox(height: 16),
          TextField(
            controller: _nombre,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Nombre del plato',
              prefixIcon: Icon(Icons.restaurant_rounded),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _desc,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              prefixIcon: Icon(Icons.notes_rounded),
            ),
          ),
          if (!_editando) ...[
            const SectionTitle('Platos frecuentes'),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _frecuentes
                  .map((f) => ActionChip(
                        avatar: Icon(f.$5, size: 18, color: AppColors.primary),
                        label: Text(f.$1),
                        onPressed: () => setState(() {
                          _nombre.text = f.$1;
                          _desc.text = f.$2;
                          _cat = f.$3;
                          _precio = f.$4;
                          _icon = f.$5;
                          _color = f.$6;
                        }),
                      ))
                  .toList(),
            ),
          ],
          const SectionTitle('Categoría'),
          Wrap(
            spacing: 8,
            children: categorias
                .map((c) => ChoiceChip(
                      label: Text(c),
                      selected: _cat == c,
                      onSelected: (_) => setState(() => _cat = c),
                    ))
                .toList(),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _paso(
                  'Precio',
                  money(_precio),
                  () => setState(() => _precio -= 0.25),
                  () => setState(() => _precio += 0.25),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _paso(
                  'Stock',
                  '$_stock',
                  () => setState(() => _stock -= 5),
                  () => setState(() => _stock += 5),
                ),
              ),
            ],
          ),
          const SectionTitle('Ícono y color'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: iconosPlato
                .map((i) => InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => _icon = i),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _icon == i
                              ? AppColors.primary
                              : AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(i,
                            color:
                                _icon == i ? Colors.white : AppColors.primary),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: coloresPlato
                .map((c) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => setState(() => _color = c),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: c,
                          child: _color == c
                              ? const Icon(Icons.check_rounded,
                                  color: Colors.white)
                              : null,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Tarjeta(
            child: SwitchListTile(
              value: _disp,
              onChanged: (v) => setState(() => _disp = v),
              title: const Text('Disponible en el menú'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton.icon(
            onPressed: _guardar,
            icon: const Icon(Icons.save_rounded),
            label: Text(_editando ? 'Guardar cambios' : 'Crear plato'),
          ),
        ),
      ),
    );
  }
}
