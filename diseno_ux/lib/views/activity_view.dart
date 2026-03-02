import 'package:flutter/material.dart';

import '../app_palette.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        const Text(
          'Actividad',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Revisa el historial reciente de eventos en tus cultivos.',
          style: TextStyle(color: AppPalette.textSecondary),
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _MiniStat(label: 'Hoy', value: '5', icon: Icons.today_rounded),
                const SizedBox(width: 10),
                _MiniStat(
                  label: 'Semana',
                  value: '18',
                  icon: Icons.date_range_rounded,
                ),
                const SizedBox(width: 10),
                _MiniStat(
                  label: 'Alertas',
                  value: '2',
                  icon: Icons.warning_amber_rounded,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Historial reciente',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        const _ActivityTile(
          icon: Icons.water_drop_rounded,
          title: 'Riego completado',
          subtitle: 'Huerto Principal · Lote A',
          time: 'Hoy · 6:00 PM',
        ),
        const SizedBox(height: 8),
        const _ActivityTile(
          icon: Icons.thermostat_rounded,
          title: 'Registro de temperatura',
          subtitle: 'Invernadero Norte · 27°C',
          time: 'Hoy · 3:20 PM',
        ),
        const SizedBox(height: 8),
        const _ActivityTile(
          icon: Icons.science_rounded,
          title: 'Lectura de pH actualizada',
          subtitle: 'Parcela Experimental · pH 6.4',
          time: 'Ayer · 8:45 AM',
        ),
        const SizedBox(height: 8),
        const _ActivityTile(
          icon: Icons.qr_code_scanner_rounded,
          title: 'Escaneo QR de lote',
          subtitle: 'Huerto Principal · Lote C',
          time: 'Ayer · 7:10 AM',
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF6F0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppPalette.primary),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppPalette.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppPalette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEAF6F0),
          child: Icon(icon, color: AppPalette.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          time,
          style: const TextStyle(fontSize: 12, color: AppPalette.textSecondary),
        ),
        onTap: () {},
      ),
    );
  }
}
