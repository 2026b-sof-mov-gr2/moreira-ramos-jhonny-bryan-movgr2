import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../student/profile_screen.dart';
import 'dishes_screen.dart';
import 'staff_orders_screen.dart';

/// Navegación del personal del comedor: Pedidos · Platos · Perfil.
class StaffShell extends StatefulWidget {
  const StaffShell({super.key});

  @override
  State<StaffShell> createState() => _StaffShellState();
}

class _StaffShellState extends State<StaffShell> {
  int _i = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final pendientes = store.pedidos
            .where((p) => p.estado == EstadoPedido.pendiente)
            .length;
        return Scaffold(
          body: IndexedStack(
            index: _i,
            children: const [
              StaffOrdersScreen(),
              DishesScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _i,
            onDestinationSelected: (i) => setState(() => _i = i),
            destinations: [
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: pendientes > 0,
                  label: Text('$pendientes'),
                  child: const Icon(Icons.receipt_long_outlined),
                ),
                selectedIcon: const Icon(Icons.receipt_long_rounded),
                label: 'Pedidos',
              ),
              const NavigationDestination(
                icon: Icon(Icons.restaurant_outlined),
                selectedIcon: Icon(Icons.restaurant_rounded),
                label: 'Platos',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Perfil',
              ),
            ],
          ),
        );
      },
    );
  }
}
