import 'package:flutter/material.dart';

import '../theme/betah_colors.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            color: BetahColors.greenPale,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: BetahColors.green, size: 30),
        ),
        const SizedBox(height: 15),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: BetahColors.muted, fontSize: 12),
        ),
      ],
    );
  }
}
