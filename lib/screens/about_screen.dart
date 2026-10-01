import 'package:flutter/material.dart';

import '../theme/betah_colors.dart';
import '../widgets/listing_widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Betah')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 32),
        children: [
          const Center(child: BetahMark(size: 76)),
          const SizedBox(height: 18),
          Text(
            'Betah',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 7),
          const Text(
            'Cari kos, rasa rumah.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: BetahColors.green,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Betah membantu kamu menemukan hunian kos yang sesuai kebutuhan, lokasi, dan rencana tinggal di Surabaya.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: BetahColors.muted,
              height: 1.55,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 28),
          const Divider(color: BetahColors.line),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Versi aplikasi'),
            trailing: Text('1.0.0', style: TextStyle(color: BetahColors.muted)),
          ),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Wilayah layanan'),
            trailing: Text(
              'Surabaya',
              style: TextStyle(color: BetahColors.muted),
            ),
          ),
        ],
      ),
    );
  }
}
