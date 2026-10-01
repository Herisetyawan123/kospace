import 'package:flutter/material.dart';

import '../theme/betah_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.displayName,
    this.email,
    this.onSignOut,
    this.onUpdateDisplayName,
    this.onOpenFavorites,
  });

  final String? displayName;
  final String? email;
  final Future<void> Function()? onSignOut;
  final Future<void> Function(String value)? onUpdateDisplayName;
  final VoidCallback? onOpenFavorites;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _name;

  String get _fallbackName =>
      widget.email?.split('@').first ?? 'Damar Ardiansyah';

  @override
  void initState() {
    super.initState();
    _name = widget.displayName?.trim().isNotEmpty == true
        ? widget.displayName!.trim()
        : _fallbackName;
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.displayName != widget.displayName &&
        widget.displayName?.trim().isNotEmpty == true) {
      _name = widget.displayName!.trim();
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailLabel = widget.email ?? 'damar.ardi@email.com';
    final initials = _name
        .split(RegExp(r'[ ._-]+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 28),
        children: [
          Text('Profil', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          Material(
            color: BetahColors.green,
            borderRadius: BorderRadius.circular(19),
            child: InkWell(
              onTap: _editProfile,
              borderRadius: BorderRadius.circular(19),
              child: Padding(
                padding: const EdgeInsets.all(18),
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
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: BetahColors.greenDeep,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            emailLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFD9E8E1),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 23),
          const _ProfileSectionLabel('AKUN'),
          _ProfileMenuTile(
            icon: Icons.person_outline_rounded,
            title: 'Data diri',
            subtitle: 'Nama dan email akun',
            onTap: _editProfile,
          ),
          _ProfileMenuTile(
            icon: Icons.favorite_border_rounded,
            title: 'Kos tersimpan',
            subtitle: 'Kelola daftar favoritmu',
            onTap:
                widget.onOpenFavorites ??
                () => _showMessage('Daftar kos tersimpan belum tersedia.'),
          ),
          const SizedBox(height: 16),
          const _ProfileSectionLabel('LAINNYA'),
          _ProfileMenuTile(
            icon: Icons.notifications_none_rounded,
            title: 'Notifikasi',
            subtitle: 'Atur kabar terbaru tentang kos',
            onTap: _showNotificationSettings,
          ),
          _ProfileMenuTile(
            icon: Icons.help_outline_rounded,
            title: 'Pusat bantuan',
            subtitle: 'Temukan jawaban dan panduan',
            onTap: _showHelp,
          ),
          _ProfileMenuTile(
            icon: Icons.info_outline_rounded,
            title: 'Tentang Betah',
            subtitle: 'Versi aplikasi 1.0.0',
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Betah',
              applicationVersion: '1.0.0',
              applicationLegalese: 'Cari kos, rasa rumah.',
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: _confirmSignOut,
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

  Future<void> _editProfile() async {
    final updatedName = await showDialog<String>(
      context: context,
      builder: (context) => _EditNameDialog(initialName: _name),
    );
    final trimmedName = updatedName?.trim();
    if (trimmedName == null || trimmedName.isEmpty) return;

    try {
      await widget.onUpdateDisplayName?.call(trimmedName);
      if (!mounted) return;
      setState(() => _name = trimmedName);
      _showMessage('Nama profil berhasil diperbarui.');
    } catch (_) {
      if (mounted) _showMessage('Nama profil gagal diperbarui. Coba lagi.');
    }
  }

  void _showNotificationSettings() {
    var pushEnabled = true;
    var emailEnabled = false;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  title: Text(
                    'Notifikasi',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text('Pilih kabar yang ingin kamu terima.'),
                ),
                SwitchListTile(
                  title: const Text('Notifikasi aplikasi'),
                  value: pushEnabled,
                  onChanged: (value) =>
                      setSheetState(() => pushEnabled = value),
                ),
                SwitchListTile(
                  title: const Text('Info melalui email'),
                  value: emailEnabled,
                  onChanged: (value) =>
                      setSheetState(() => emailEnabled = value),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Selesai'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHelp() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(4, 4, 4, 12),
              child: Text(
                'Pusat bantuan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
            const ExpansionTile(
              title: Text('Bagaimana cara menyimpan kos?'),
              children: [
                ListTile(
                  title: Text(
                    'Ketuk ikon hati pada kartu kos atau halaman detail. Kos akan muncul di tab Favorit.',
                  ),
                ),
              ],
            ),
            const ExpansionTile(
              title: Text('Bagaimana cara mencari berdasarkan area?'),
              children: [
                ListTile(
                  title: Text(
                    'Gunakan kolom pencarian di Beranda, lalu masukkan nama area di Surabaya.',
                  ),
                ),
              ],
            ),
            const ExpansionTile(
              title: Text('Bagaimana jika lupa kata sandi?'),
              children: [
                ListTile(
                  title: Text(
                    'Pilih “Lupa kata sandi?” di halaman Login untuk menerima tautan reset melalui email.',
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSignOut() async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu perlu login lagi untuk membuka akun ini.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (shouldSignOut != true) return;

    try {
      await widget.onSignOut?.call();
      if (widget.onSignOut == null && mounted) {
        _showMessage('Akun demo tidak perlu keluar.');
      }
    } catch (_) {
      if (mounted) _showMessage('Gagal keluar. Coba lagi.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _EditNameDialog extends StatefulWidget {
  const _EditNameDialog({required this.initialName});

  final String initialName;

  @override
  State<_EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<_EditNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Data diri'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(labelText: 'Nama lengkap'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Simpan'),
        ),
      ],
    );
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
