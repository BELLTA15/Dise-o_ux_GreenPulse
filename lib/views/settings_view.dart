import 'package:flutter/material.dart';

import '../app_palette.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        const Text(
          'Ajustes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Configura tus preferencias principales de la aplicación.',
          style: TextStyle(color: AppPalette.textSecondary),
        ),
        const SizedBox(height: 14),
        Card(
          child: Column(
            children: const [
              _SettingSwitchTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notificaciones',
                subtitle: 'Alertas de riego y eventos',
                value: true,
              ),
              Divider(height: 1),
              _SettingSwitchTile(
                icon: Icons.volume_up_outlined,
                title: 'Sonidos',
                subtitle: 'Avisos de actividad y alertas',
                value: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const _SettingOptionTile(
          icon: Icons.language_rounded,
          title: 'Idioma',
          subtitle: 'Español',
        ),
        const SizedBox(height: 8),
        const _SettingOptionTile(
          icon: Icons.palette_outlined,
          title: 'Tema',
          subtitle: 'Claro (GreenPulse)',
        ),
        const SizedBox(height: 8),
        const _SettingOptionTile(
          icon: Icons.security_rounded,
          title: 'Privacidad',
          subtitle: 'Permisos y seguridad',
        ),
        const SizedBox(height: 8),
        const _SettingOptionTile(
          icon: Icons.info_outline_rounded,
          title: 'Acerca de',
          subtitle: 'Versión 1.0.0',
        ),
      ],
    );
  }
}

class _SettingSwitchTile extends StatelessWidget {
  const _SettingSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFEAF6F0),
        child: Icon(icon, color: AppPalette.primary),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(value: value, onChanged: (_) {}),
    );
  }
}

class _SettingOptionTile extends StatelessWidget {
  const _SettingOptionTile({
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEAF6F0),
          child: Icon(icon, color: AppPalette.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {},
      ),
    );
  }
}
