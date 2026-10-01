import 'package:flutter/material.dart';

import '../theme/betah_colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pusat bantuan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        children: [
          Text(
            'Ada yang bisa kami bantu?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 7),
          const Text(
            'Temukan jawaban seputar pencarian dan akun Betah.',
            style: TextStyle(color: BetahColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 20),
          const _HelpTopic(
            question: 'Bagaimana cara menyimpan kos?',
            answer:
                'Ketuk ikon hati pada kartu kos atau halaman detail. Kos tersimpan akan muncul di tab Favorit.',
          ),
          const _HelpTopic(
            question: 'Bagaimana cara mencari berdasarkan area?',
            answer:
                'Gunakan kolom pencarian di Beranda dan masukkan nama area, kampus, atau alamat di Surabaya.',
          ),
          const _HelpTopic(
            question: 'Bagaimana cara memperbarui profil?',
            answer:
                'Buka tab Profil, pilih Data diri, lalu lengkapi informasi dan preferensi kos yang kamu cari.',
          ),
          const _HelpTopic(
            question: 'Bagaimana jika lupa kata sandi?',
            answer:
                'Di halaman Login, pilih “Lupa kata sandi?” untuk menerima tautan reset melalui email.',
          ),
          const _HelpTopic(
            question: 'Apakah data profil bisa diubah?',
            answer:
                'Bisa. Nama akun diperbarui ke Firebase Authentication dan preferensi pencarian tersimpan di perangkat ini.',
          ),
        ],
      ),
    );
  }
}

class _HelpTopic extends StatelessWidget {
  const _HelpTopic({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: BetahColors.paper,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: BetahColors.line),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: const TextStyle(
                color: BetahColors.muted,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
