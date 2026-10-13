import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momias_guanajuato/presentation/juego_screen.dart';

void main() {
  testWidgets('la pantalla inicia con 3 vidas y puntaje 0', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: JuegoScreen()));

    expect(find.text('Vidas: 3'), findsOneWidget);
    expect(find.text('Puntaje: 0'), findsOneWidget);
  });
}
