import 'package:flutter/material.dart';

import '../app_palette.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        const Text(
          'Proyectos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Crea, organiza y administra tus proyectos de cultivo.',
          style: TextStyle(color: AppPalette.textSecondary),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded),
                label: const Text('Crear proyecto'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune_rounded),
                label: const Text('Administrar proyecto'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Mis proyectos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        const _ProjectTile(
          title: 'Huerto Principal',
          status: 'Activo',
          details: '4 lotes · Última actividad: hoy',
        ),
        const SizedBox(height: 10),
        const _ProjectTile(
          title: 'Invernadero Norte',
          status: 'En seguimiento',
          details: '2 lotes · Última actividad: ayer',
        ),
        const SizedBox(height: 10),
        const _ProjectTile(
          title: 'Parcela Experimental',
          status: 'Pausado',
          details: '1 lote · Última actividad: hace 3 días',
        ),
      ],
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({
    required this.title,
    required this.status,
    required this.details,
  });

  final String title;
  final String status;
  final String details;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFEAF6F0),
          child: Icon(Icons.eco_rounded, color: AppPalette.primary),
        ),
        title: Text(title),
        subtitle: Text('$status · $details'),
        trailing: OutlinedButton(
          onPressed: () {},
          child: const Text('Gestionar'),
        ),
      ),
    );
  }
}
