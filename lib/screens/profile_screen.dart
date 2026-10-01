import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/seeker_profile.dart';
import '../theme/betah_colors.dart';
import 'about_screen.dart';
import 'edit_profile_screen.dart';
import 'help_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.userId,
    this.displayName,
    this.email,
    this.onSignOut,
    this.onUpdateDisplayName,
    this.onOpenFavorites,
  });

  final String? userId;
  final String? displayName;
  final String? email;
  final Future<void> Function()? onSignOut;
  final Future<void> Function(String value)? onUpdateDisplayName;
  final VoidCallback? onOpenFavorites;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late SeekerProfile _profile;
  late final String _storageKey;

  String get _fallbackName =>
      widget.email?.split('@').first ?? 'Damar Ardiansyah';

  @override
  void initState() {
    super.initState();
    _storageKey = 'betah_seeker_profile_${widget.userId ?? 'demo'}';
    _profile = SeekerProfile(
      name: widget.displayName?.trim().isNotEmpty == true
          ? widget.displayName!.trim()
          : _fallbackName,
    );
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = preferences.getString(_storageKey);
      if (saved == null) return;
      final profile = SeekerProfile.fromJson(saved);
      if (!mounted) return;
      setState(() {
        _profile = SeekerProfile(
          name: widget.displayName?.trim().isNotEmpty == true
              ? widget.displayName!.trim()
              : profile.name,
          phone: profile.phone,
          address: profile.address,
          birthDate: profile.birthDate,
          gender: profile.gender,
          preferredArea: profile.preferredArea,
          monthlyBudget: profile.monthlyBudget,
          moveInDate: profile.moveInDate,
          occupation: profile.occupation,
        );
      });
    } catch (_) {
      // Use account defaults if saved local profile data cannot be read.
    }
  }

  Future<void> _saveProfile(SeekerProfile profile) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_storageKey, profile.toJson());
    if (profile.name != widget.displayName) {
      try {
        await widget.onUpdateDisplayName?.call(profile.name);
      } catch (_) {
        if (mounted) {
          _showMessage(
            'Preferensi tersimpan, tetapi nama akun gagal diperbarui.',
          );
        }
      }
    }
  }

  Future<void> _editProfile() async {
    final updatedProfile = await Navigator.of(context).push<SeekerProfile>(
      MaterialPageRoute<SeekerProfile>(
        builder: (context) => EditProfileScreen(
          initialProfile: _profile,
          email: widget.email ?? '',
          onSave: _saveProfile,
        ),
      ),
    );
    if (updatedProfile == null || !mounted) return;
    setState(() => _profile = updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    final emailLabel = widget.email ?? 'damar.ardi@email.com';
    final initials = _profile.name
        .split(RegExp(r'[ ._-]+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
    final details = [
      if (_profile.preferredArea.isNotEmpty) _profile.preferredArea,
      if (_profile.monthlyBudget.isNotEmpty)
        'Budget Rp${_profile.monthlyBudget}/bln',
    ];

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
                            _profile.name,
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
                          if (details.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            Text(
                              details.join(' · '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFFD9E8E1),
                                fontSize: 10,
                              ),
                            ),
                          ],
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
            subtitle: 'Profil dan preferensi kos',
            onTap: _editProfile,
          ),
          _ProfileMenuTile(
            icon: Icons.favorite_border_rounded,
            title: 'Kos tersimpan',
            subtitle: 'Kelola daftar favoritmu',
            onTap: widget.onOpenFavorites ?? () {},
          ),
          const SizedBox(height: 16),
          const _ProfileSectionLabel('INFORMASI'),
          _ProfileMenuTile(
            icon: Icons.help_outline_rounded,
            title: 'Pusat bantuan',
            subtitle: 'Panduan menggunakan Betah',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (context) => const HelpScreen()),
            ),
          ),
          _ProfileMenuTile(
            icon: Icons.info_outline_rounded,
            title: 'Tentang Betah',
            subtitle: 'Versi aplikasi 1.0.0',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const AboutScreen(),
              ),
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
