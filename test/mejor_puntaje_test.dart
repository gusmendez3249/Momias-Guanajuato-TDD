import 'package:flutter_test/flutter_test.dart';
import 'package:momias_guanajuato/datos/preferencias_puntaje.dart';
import 'package:momias_guanajuato/logica/mejor_puntaje.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repositorio en memoria: la "costura" que permite probar sin disco.
class RepositorioEnMemoria implements RepositorioPuntaje {
  int valor;
  RepositorioEnMemoria([this.valor = 0]);

  @override
  Future<int> leer() async => valor;

  @override
  Future<void> guardar(int puntaje) async => valor = puntaje;
}

void main() {
  group('MejorPuntaje (reto 4)', () {
    test('registrar guarda el puntaje cuando supera el record', () async {
      final repo = RepositorioEnMemoria(0);

      final mejor = await MejorPuntaje(repo).registrar(100);

      expect(mejor, 100);
      expect(repo.valor, 100);
    });

    test('registrar no reemplaza un record mayor', () async {
      final repo = RepositorioEnMemoria(200);

      final mejor = await MejorPuntaje(repo).registrar(50);

      expect(mejor, 200);
      expect(repo.valor, 200);
    });

    test('registrar un puntaje igual al record no cambia nada', () async {
      final repo = RepositorioEnMemoria(150);

      final mejor = await MejorPuntaje(repo).registrar(150);

      expect(mejor, 150);
    });

    test('actual devuelve el record guardado', () async {
      expect(await MejorPuntaje(RepositorioEnMemoria(80)).actual(), 80);
    });
  });

  group('PreferenciasPuntaje con shared_preferences (reto 4)', () {
    test('sin datos previos el record es 0', () async {
      SharedPreferences.setMockInitialValues({});

      expect(await PreferenciasPuntaje().leer(), 0);
    });

    test('el record guardado se recupera en una instancia nueva', () async {
      SharedPreferences.setMockInitialValues({});

      await PreferenciasPuntaje().guardar(70);

      expect(await PreferenciasPuntaje().leer(), 70);
    });
  });
}
