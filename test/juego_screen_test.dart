import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momias_guanajuato/logica/mejor_puntaje.dart';
import 'package:momias_guanajuato/presentation/juego_screen.dart';
import 'package:momias_guanajuato/presentation/vidas_hud.dart';

class _RepoFalso implements RepositorioPuntaje {
  final int valor;
  _RepoFalso(this.valor);

  @override
  Future<int> leer() async => valor;

  @override
  Future<void> guardar(int puntaje) async {}
}

void main() {
  group('VidasHud (reto 2)', () {
    Future<void> montar(WidgetTester tester, int vidas) {
      return tester.pumpWidget(
        MaterialApp(home: Scaffold(body: VidasHud(vidas: vidas, maximo: 3))),
      );
    }

    testWidgets('con 3 vidas muestra 3 corazones llenos y ninguno vacio', (tester) async {
      await montar(tester, 3);

      expect(find.byIcon(Icons.favorite), findsNWidgets(3));
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('con 1 vida muestra 1 corazon lleno y 2 vacios', (tester) async {
      await montar(tester, 1);

      expect(find.byIcon(Icons.favorite), findsNWidgets(1));
      expect(find.byIcon(Icons.favorite_border), findsNWidgets(2));
    });

    testWidgets('con 0 vidas todos los corazones estan vacios', (tester) async {
      await montar(tester, 0);

      expect(find.byIcon(Icons.favorite), findsNothing);
      expect(find.byIcon(Icons.favorite_border), findsNWidgets(3));
    });
  });

  group('JuegoScreen', () {
    testWidgets('inicia en el nivel 1 con 3 corazones y puntaje 0', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: JuegoScreen(repositorio: _RepoFalso(0))),
      );

      expect(find.text('Nivel 1'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNWidgets(3));
      expect(find.text('Puntaje: 0'), findsOneWidget);
    });

    testWidgets('muestra el mejor puntaje guardado (reto 4)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: JuegoScreen(repositorio: _RepoFalso(350))),
      );
      await tester.pump();

      expect(find.text('Mejor: 350'), findsOneWidget);
    });
  });
}
