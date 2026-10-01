// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kos/screens/app_shell.dart';
import 'package:kos/screens/login_screen.dart';
import 'package:kos/screens/onboarding_screen.dart';

void main() {
  testWidgets('onboarding can advance and finish', (WidgetTester tester) async {
    var finished = false;
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(onFinish: () async => finished = true),
      ),
    );

    expect(find.text('Cari kos senyaman rumah'), findsOneWidget);
    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();
    expect(find.text('Dekat dengan tujuanmu'), findsOneWidget);

    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();
    expect(find.text('Temukan tempat pulangmu'), findsOneWidget);

    await tester.tap(find.text('Mulai Cari Kos'));
    await tester.pump();
    expect(finished, isTrue);
  });

  testWidgets('login screen can switch to account creation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('Login'), findsOneWidget);
    await tester.tap(find.text('Daftar di sini'));
    await tester.pump();

    expect(find.text('Buat akun'), findsOneWidget);
    expect(find.text('Nama lengkap'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });

  testWidgets('profile menu items open and perform their actions', (
    WidgetTester tester,
  ) async {
    var signedOut = false;
    await tester.pumpWidget(
      MaterialApp(
        home: AppShell(
          onSignOut: () async {
            signedOut = true;
          },
        ),
      ),
    );

    await tester.tap(find.text('Profil').last);
    await tester.pump();

    await tester.tap(find.text('Data diri'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Nadia Putri');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Nadia Putri'), findsOneWidget);

    await tester.tap(find.text('Kos tersimpan'));
    await tester.pump();
    expect(find.text('2 tempat yang kamu suka'), findsOneWidget);

    await tester.tap(find.text('Profil').last);
    await tester.pump();
    await tester.tap(find.text('Notifikasi'));
    await tester.pumpAndSettle();
    expect(find.text('Notifikasi aplikasi'), findsOneWidget);
    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Pusat bantuan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pusat bantuan'));
    await tester.pumpAndSettle();
    expect(find.text('Bagaimana cara menyimpan kos?'), findsOneWidget);
    await tester.tap(find.text('Bagaimana cara menyimpan kos?'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Ketuk ikon hati'), findsOneWidget);
    await tester.ensureVisible(find.text('Tutup'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Tentang Betah'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tentang Betah'));
    await tester.pumpAndSettle();
    expect(find.text('1.0.0'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Keluar dari akun'));
    await tester.tap(find.text('Keluar dari akun'));
    await tester.pumpAndSettle();
    expect(find.text('Keluar dari akun?'), findsOneWidget);
    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();
    expect(signedOut, isTrue);
  });

  testWidgets('home, favorites, and detail screens are reachable', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AppShell()));
    await tester.pump();

    expect(find.text('Damar, cari kos di mana?'), findsOneWidget);
    expect(find.text('Temukan tempat\npulang di Surabaya.'), findsOneWidget);

    await tester.tap(find.text('Favorit'));
    await tester.pump();
    expect(find.text('Kos tersimpan'), findsOneWidget);
    expect(find.text('2 tempat yang kamu suka'), findsOneWidget);

    await tester.tap(find.byTooltip('Hapus dari favorit').first);
    await tester.pump();
    expect(find.text('1 tempat yang kamu suka'), findsOneWidget);

    await tester.tap(find.text('Beranda'));
    await tester.pump();
    await tester.ensureVisible(find.text('Kost Melati Residence').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kost Melati Residence').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Fasilitas kamar'), findsOneWidget);
  });
}
