// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences.setMockInitialValues({});
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
    expect(find.text('Edit profil'), findsOneWidget);
    expect(find.text('Preferensi mencari kos'), findsOneWidget);
    expect(find.text('Tanggal lahir'), findsOneWidget);
    expect(find.text('Gender'), findsOneWidget);
    expect(find.text('Area kos yang dicari'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('profile_name')),
      'Nadia Putri',
    );
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('profile_area')),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(
      find.byKey(const ValueKey('profile_area')),
      'Rungkut',
    );
    await tester.scrollUntilVisible(
      find.text('Simpan perubahan'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan perubahan'));
    await tester.pumpAndSettle();
    expect(find.text('Edit profil'), findsNothing);
    expect(find.text('Nadia Putri'), findsOneWidget);

    await tester.tap(find.text('Data diri'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('profile_name')))
          .controller
          ?.text,
      'Nadia Putri',
    );
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Kos tersimpan'));
    await tester.pump();
    expect(find.text('2 tempat yang kamu suka'), findsOneWidget);

    await tester.tap(find.text('Profil').last);
    await tester.pump();
    expect(find.text('Notifikasi'), findsNothing);

    await tester.ensureVisible(find.text('Pusat bantuan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pusat bantuan'));
    await tester.pumpAndSettle();
    expect(find.text('Pusat bantuan'), findsOneWidget);
    expect(find.text('Bagaimana cara menyimpan kos?'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Tentang Betah'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tentang Betah'));
    await tester.pumpAndSettle();
    expect(find.text('Cari kos, rasa rumah.'), findsOneWidget);
    expect(find.text('1.0.0'), findsOneWidget);
    await tester.pageBack();
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
