// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:kos/app.dart';

void main() {
  testWidgets('home, favorites, and detail screens are reachable', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BetahApp());
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
    await tester.tap(find.text('Kost Melati Residence').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Fasilitas kamar'), findsOneWidget);
  });
}
