import 'package:flutter/material.dart';

import '../app_palette.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        const Text(
          'Perfil',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFEAF6F0),
                  child: Icon(
                    Icons.person_rounded,
                    size: 34,
                    color: AppPalette.primary,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lenny Rincón',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppPalette.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'lenny@greenpulse.app',
                        style: TextStyle(color: AppPalette.textSecondary),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Productor',
                        style: TextStyle(color: AppPalette.textSecondary),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(onPressed: () {}, child: const Text('Editar')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Cuenta',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        const _ProfileActionTile(
          icon: Icons.badge_outlined,
          title: 'Datos personales',
          subtitle: 'Nombre, correo y teléfono',
        ),
        const SizedBox(height: 8),
        const _ProfileActionTile(
          icon: Icons.lock_outline_rounded,
          title: 'Seguridad',
          subtitle: 'Contraseña y acceso',
        ),
        const SizedBox(height: 8),
        const _ProfileActionTile(
          icon: Icons.notifications_none_rounded,
          title: 'Notificaciones',
          subtitle: 'Recordatorios y alertas',
        ),
        const SizedBox(height: 8),
        const _ProfileActionTile(
          icon: Icons.help_outline_rounded,
          title: 'Ayuda y soporte',
          subtitle: 'Centro de ayuda',
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Cerrar sesión'),
        ),
      ],
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
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
