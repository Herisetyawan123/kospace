import 'package:flutter/material.dart';

import 'screens/auth_gate.dart';
import 'theme/betah_colors.dart';

class BetahApp extends StatelessWidget {
  const BetahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Betah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: BetahColors.canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: BetahColors.green,
          primary: BetahColors.green,
          secondary: BetahColors.orange,
          surface: BetahColors.paper,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: BetahColors.ink,
            fontFamily: 'Georgia',
            fontSize: 27,
            height: 1.12,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            color: BetahColors.ink,
            fontFamily: 'Georgia',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(color: BetahColors.ink, fontSize: 14),
        ),
      ),
      home: const AuthGate(),
    );
  }
}
