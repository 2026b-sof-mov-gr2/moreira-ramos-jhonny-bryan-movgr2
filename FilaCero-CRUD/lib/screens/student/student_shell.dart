import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import 'menu_screen.dart';
import 'my_orders_screen.dart';
import 'profile_screen.dart';

/// Navegación del estudiante: Menú · Mis pedidos · Perfil.
class StudentShell extends StatefulWidget {
  const StudentShell({super.key});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _i = 0;

  void irA(int i) => setState(() => _i = i);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final activos =
            store.misPedidos.where((p) => p.estado.activo).length;
        return Scaffold(
          body: IndexedStack(
            index: _i,
            children: [
              MenuScreen(onVerPedidos: () => irA(1)),
              const MyOrdersScreen(),
              const ProfileScreen(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _i,
            onDestinationSelected: irA,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.restaurant_menu_outlined),
                selectedIcon: Icon(Icons.restaurant_menu_rounded),
                label: 'Menú',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: activos > 0,
                  label: Text('$activos'),
                  child: const Icon(Icons.receipt_long_outlined),
                ),
                selectedIcon: const Icon(Icons.receipt_long_rounded),
                label: 'Mis pedidos',
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
