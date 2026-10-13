import 'package:flutter_test/flutter_test.dart';
import 'package:momias_guanajuato/logica/estado_juego.dart';
import 'package:momias_guanajuato/logica/niveles.dart';

void main() {
  test('el juego tiene al menos dos niveles', () {
    expect(Niveles.todos.length, greaterThanOrEqualTo(2));
  });

  test('el segundo nivel es mas largo y tiene mas plataformas, momias y calaveritas', () {
    final n1 = Niveles.todos[0].crearMotor();
    final n2 = Niveles.todos[1].crearMotor();

    expect(n2.anchoNivel, greaterThan(n1.anchoNivel));
    expect(n2.plataformas.length, greaterThan(n1.plataformas.length));
    expect(n2.momias.length, greaterThan(n1.momias.length));
    expect(n2.calaveritas.length, greaterThan(n1.calaveritas.length));
  });

  test('el segundo nivel incluye una momia vertical', () {
    final n2 = Niveles.todos[1].crearMotor();

    expect(n2.momias.any((m) => m.velocidadY != 0), true);
  });

  test('cada nivel tiene la meta dentro de sus limites y arranca en jugando', () {
    for (final nivel in Niveles.todos) {
      final motor = nivel.crearMotor();
      expect(motor.posicionMeta, lessThan(motor.anchoNivel));
      expect(motor.estado, EstadoJuego.jugando);
      expect(motor.vidas, 3);
    }
  });

  test('crearMotor devuelve estados independientes en cada llamada', () {
    final a = Niveles.todos[0].crearMotor();
    final b = Niveles.todos[0].crearMotor();

    a.vidas = 0;
    a.calaveritas.first.recolectada = true;

    expect(identical(a.personaje, b.personaje), false);
    expect(b.vidas, 3);
    expect(b.calaveritas.first.recolectada, false);
  });
}
