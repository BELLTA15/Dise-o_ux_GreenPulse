import 'package:flutter/material.dart';

import '../app_palette.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppPalette.primary,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Bienvenido a GreenPulse!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Gestiona tus cultivos, registra actividades y consulta el estado de tus lotes en un solo lugar.',
                style: TextStyle(color: Color(0xFFE4F5EC), height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Opciones principales',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.25,
          children: const [
            _OptionCard(
              icon: Icons.qr_code_scanner_rounded,
              title: 'Escanear QR',
              subtitle: 'Identificar lote rápido',
            ),
            _OptionCard(
              icon: Icons.thermostat_rounded,
              title: 'Variables',
              subtitle: 'Temperatura, humedad, pH',
            ),
            _OptionCard(
              icon: Icons.calendar_month_rounded,
              title: 'Calendario',
              subtitle: 'Riego y fertilización',
            ),
            _OptionCard(
              icon: Icons.warning_amber_rounded,
              title: 'Alertas',
              subtitle: 'Recordatorios importantes',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFEAF6F0),
              child: Icon(Icons.eco_rounded, color: AppPalette.primary),
            ),
            title: const Text('Proyecto activo: Huerto Principal'),
            subtitle: const Text('Próximo riego: hoy 6:00 PM'),
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF6F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppPalette.primary),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppPalette.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
