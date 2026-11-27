import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 52,
                  backgroundColor: AppColors.primaryLight,
                  child: Text('E',
                      style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary)),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const LabeledField(
              label: 'Nombre completo',
              hint: 'Estudiante EPN',
              icon: Icons.person_outline_rounded),
          const LabeledField(
              label: 'Correo institucional',
              hint: 'estudiante@epn.edu.ec',
              icon: Icons.mail_outline_rounded),
          const LabeledField(
              label: 'Teléfono',
              hint: '09XXXXXXXX',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone),
          const SizedBox(height: 4),
          const SectionTitle('Preferencias alimentarias'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Vegetariano', 'Sin gluten', 'Sin lactosa', 'Picante']
                .map((p) => FilterChip(
                      label: Text(p),
                      selected: p == 'Picante',
                      onSelected: (_) {},
                    ))
                .toList(),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
          child: FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Guardar cambios'),
          ),
        ),
      ),
    );
  }
}
