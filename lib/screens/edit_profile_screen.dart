import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/seeker_profile.dart';
import '../theme/betah_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.initialProfile,
    required this.email,
    required this.onSave,
  });

  final SeekerProfile initialProfile;
  final String email;
  final Future<void> Function(SeekerProfile profile) onSave;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _areaController;
  late final TextEditingController _budgetController;
  late DateTime? _birthDate;
  late DateTime? _moveInDate;
  late String _gender;
  late String _occupation;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.initialProfile;
    _nameController = TextEditingController(text: profile.name);
    _phoneController = TextEditingController(text: profile.phone);
    _addressController = TextEditingController(text: profile.address);
    _areaController = TextEditingController(text: profile.preferredArea);
    _budgetController = TextEditingController(text: profile.monthlyBudget);
    _birthDate = profile.birthDate;
    _moveInDate = profile.moveInDate;
    _gender = profile.gender;
    _occupation = profile.occupation;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool forBirthDate}) async {
    final today = DateTime.now();
    final current = forBirthDate ? _birthDate : _moveInDate;
    final firstDate = forBirthDate ? DateTime(1940) : today;
    final lastDate = forBirthDate ? today : DateTime(today.year + 5);
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? (forBirthDate ? DateTime(2000) : today),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (forBirthDate) {
        _birthDate = picked;
      } else {
        _moveInDate = picked;
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final profile = SeekerProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      birthDate: _birthDate,
      gender: _gender,
      preferredArea: _areaController.text.trim(),
      monthlyBudget: _budgetController.text.trim(),
      moveInDate: _moveInDate,
      occupation: _occupation,
    );
    try {
      await widget.onSave(profile);
      if (mounted) Navigator.of(context).pop(profile);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil gagal disimpan. Coba lagi.')),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profil')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
            children: [
              const Text(
                'Data diri',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('profile_name'),
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: _decoration('Nama lengkap', Icons.person_outline),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama lengkap wajib diisi.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: widget.email,
                readOnly: true,
                decoration: _decoration('Email akun', Icons.mail_outline),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: _decoration('Nomor telepon', Icons.phone_outlined),
              ),
              const SizedBox(height: 12),
              _DateField(
                label: 'Tanggal lahir',
                value: _formatDate(_birthDate),
                onTap: () => _pickDate(forBirthDate: true),
              ),
              if (_birthDate != null) ...[
                const SizedBox(height: 6),
                Text(
                  'Umur ${_age(_birthDate!)} tahun',
                  style: const TextStyle(
                    color: BetahColors.muted,
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _gender.isEmpty ? null : _gender,
                decoration: _decoration('Gender', Icons.wc_outlined),
                items: const [
                  DropdownMenuItem(
                    value: 'Perempuan',
                    child: Text('Perempuan'),
                  ),
                  DropdownMenuItem(
                    value: 'Laki-laki',
                    child: Text('Laki-laki'),
                  ),
                  DropdownMenuItem(
                    value: 'Tidak ingin menyebutkan',
                    child: Text('Tidak ingin menyebutkan'),
                  ),
                ],
                onChanged: (value) => setState(() => _gender = value ?? ''),
              ),
              const SizedBox(height: 24),
              const Text(
                'Preferensi mencari kos',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 2,
                maxLines: 3,
                decoration: _decoration(
                  'Alamat domisili saat ini',
                  Icons.home_outlined,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('profile_area'),
                controller: _areaController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: _decoration(
                  'Area kos yang dicari',
                  Icons.location_on_outlined,
                ).copyWith(hintText: 'Contoh: Rungkut, Sukolilo'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Isi area kos yang kamu cari.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.next,
                decoration: _decoration(
                  'Budget per bulan (Rp)',
                  Icons.payments_outlined,
                ).copyWith(hintText: 'Contoh: 1500000'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _occupation.isEmpty ? null : _occupation,
                decoration: _decoration(
                  'Kegiatan saat ini',
                  Icons.work_outline_rounded,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Mahasiswa',
                    child: Text('Mahasiswa'),
                  ),
                  DropdownMenuItem(value: 'Bekerja', child: Text('Bekerja')),
                  DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
                ],
                onChanged: (value) => setState(() => _occupation = value ?? ''),
              ),
              const SizedBox(height: 12),
              _DateField(
                label: 'Rencana mulai tinggal',
                value: _formatDate(_moveInDate),
                onTap: () => _pickDate(forBirthDate: false),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _isSaving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: BetahColors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  icon: _isSaving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_rounded),
                  label: Text(_isSaving ? 'Menyimpan...' : 'Simpan perubahan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 19),
      filled: true,
      fillColor: BetahColors.paper,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: BetahColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: BetahColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: BetahColors.green, width: 1.4),
      ),
    );
  }

  int _age(DateTime birthday) {
    final today = DateTime.now();
    var age = today.year - birthday.year;
    if (today.month < birthday.month ||
        (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }
    return age;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey('$label-$value'),
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.calendar_month_outlined, size: 19),
        suffixIcon: const Icon(Icons.edit_calendar_outlined, size: 18),
        hintText: 'Pilih tanggal',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
      ),
      initialValue: value,
    );
  }
}
