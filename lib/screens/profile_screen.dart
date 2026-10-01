import 'package:flutter/material.dart';

import '../theme/betah_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 28),
        children: [
          Text('Profil', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: BetahColors.green,
              borderRadius: BorderRadius.circular(19),
            ),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD98B),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Text(
                    'DA',
                    style: TextStyle(
                      color: BetahColors.greenDeep,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Damar Ardiansyah',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'damar.ardi@email.com',
                        style: TextStyle(
                          color: Color(0xFFD9E8E1),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 23),
          const _ProfileSectionLabel('AKUN'),
          _ProfileMenuTile(
            icon: Icons.person_outline_rounded,
            title: 'Data diri',
            subtitle: 'Nama, email, dan nomor telepon',
            onTap: () => _showMessage(context, 'Data profil demo.'),
          ),
          _ProfileMenuTile(
            icon: Icons.favorite_border_rounded,
            title: 'Kos tersimpan',
            subtitle: 'Kelola daftar favoritmu',
            onTap: () => _showMessage(context, 'Buka tab Favorit di bawah.'),
          ),
          const SizedBox(height: 16),
          const _ProfileSectionLabel('LAINNYA'),
          _ProfileMenuTile(
            icon: Icons.notifications_none_rounded,
            title: 'Notifikasi',
            subtitle: 'Atur kabar terbaru tentang kos',
            onTap: () => _showMessage(context, 'Pengaturan notifikasi demo.'),
          ),
          _ProfileMenuTile(
            icon: Icons.help_outline_rounded,
            title: 'Pusat bantuan',
            subtitle: 'Temukan jawaban dan panduan',
            onTap: () => _showMessage(context, 'Pusat bantuan segera hadir.'),
          ),
          _ProfileMenuTile(
            icon: Icons.info_outline_rounded,
            title: 'Tentang Betah',
            subtitle: 'Versi aplikasi 1.0.0',
            onTap: () => _showMessage(context, 'Betah · Cari kos, rasa rumah.'),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () =>
                _showMessage(context, 'Akun demo tidak perlu keluar.'),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Keluar dari akun'),
            style: OutlinedButton.styleFrom(
              foregroundColor: BetahColors.orange,
              side: const BorderSide(color: BetahColors.line),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ProfileSectionLabel extends StatelessWidget {
  const _ProfileSectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: BetahColors.muted,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: BetahColors.greenPale,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, color: BetahColors.green),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: BetahColors.muted, fontSize: 11),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: BetahColors.muted,
      ),
      onTap: onTap,
    );
  }
}
