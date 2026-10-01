import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_shell.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();

  Future<void> _finishOnboarding(SharedPreferences preferences) async {
    await preferences.setBool('betah_onboarding_complete', true);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: _preferences,
      builder: (context, preferencesSnapshot) {
        if (!preferencesSnapshot.hasData) {
          return const _StartupScreen();
        }

        final preferences = preferencesSnapshot.data!;
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          initialData: FirebaseAuth.instance.currentUser,
          builder: (context, authSnapshot) {
            final user = authSnapshot.data;
            if (user != null) {
              final name = user.displayName?.trim();
              return AppShell(
                userId: user.uid,
                displayName: name == null || name.isEmpty ? null : name,
                email: user.email,
                onSignOut: () => FirebaseAuth.instance.signOut(),
                onUpdateDisplayName: (value) async {
                  await FirebaseAuth.instance.currentUser?.updateDisplayName(
                    value,
                  );
                },
              );
            }

            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const _StartupScreen();
            }

            if (preferences.getBool('betah_onboarding_complete') != true) {
              return OnboardingScreen(
                onFinish: () => _finishOnboarding(preferences),
              );
            }
            return const LoginScreen();
          },
        );
      },
    );
  }
}

class _StartupScreen extends StatelessWidget {
  const _StartupScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
