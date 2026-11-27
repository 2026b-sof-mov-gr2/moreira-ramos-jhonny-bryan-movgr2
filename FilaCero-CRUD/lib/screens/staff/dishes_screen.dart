import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';
import 'dish_form_screen.dart';

/// CRUD de platos del menú (lista, disponibilidad, editar, eliminar).
class DishesScreen extends StatelessWidget {
  const DishesScreen({super.key});

  Future<void> _eliminar(BuildContext context, Plato p) async {
    final ok = await confirmar(context,
        titulo: '¿Eliminar "${p.nombre}"?',
        mensaje: 'El plato desaparecerá del menú de los estudiantes.');
    if (!ok || !context.mounted) return;
    final e = store.eliminarPlato(p);
    toast(context, e ?? '"${p.nombre}" eliminado', error: e != null);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Platos del menú')),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const DishFormScreen())),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nuevo plato'),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            children: [
              for (final c in categorias) ...[
                SectionTitle(
                    '$c (${store.platos.where((p) => p.categoria == c).length})'),
                ...store.platos.where((p) => p.categoria == c).map(
                      (p) => Tarjeta(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DishFormScreen(plato: p))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
                          child: Row(
                            children: [
                              PlatoThumb(plato: p, size: 48),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.nombre,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700)),
                                    Text(
                                      '${money(p.precio)} · stock ${p.stock}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: p.stock == 0
                                              ? AppColors.danger
                                              : AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: p.disponible,
                                onChanged: (v) {
                                  store.cambiarDisponible(p, v);
                                  toast(context,
                                      '"${p.nombre}" ${v ? 'disponible' : 'oculto del menú'}');
                                },
                              ),
                              IconButton(
                                onPressed: () => _eliminar(context, p),
                                icon: const Icon(Icons.delete_outline_rounded,
                                    color: AppColors.danger),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              ],
            ],
          ),
        );
      },
    );
  }
}
