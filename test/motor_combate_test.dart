import 'package:flutter_test/flutter_test.dart';
import 'package:momias_guanajuato/logica/momia.dart';
import 'package:momias_guanajuato/logica/motor_combate.dart';
import 'package:momias_guanajuato/logica/personaje.dart';

void main() {
  test('caer sobre la mitad superior de una momia la derrota', () {
    // Pie en y=104: intersecta a la momia (y=100) y esta en su mitad superior (<=116).
    final personaje = Personaje(x: 100, y: 72)..velocidadY = 5;
    final momia = Momia(x: 100, y: 100, limiteIzquierdo: 0, limiteDerecho: 200);

    final resultado = MotorCombate.resolverColision(personaje, momia);

    expect(resultado, ResultadoColisionMomia.momiaDerrotada);
    expect(momia.derrotada, true);
  });

  test('chocar de lado con una momia golpea al jugador', () {
    final personaje = Personaje(x: 90, y: 100)..velocidadY = 0;
    final momia = Momia(x: 100, y: 100, limiteIzquierdo: 0, limiteDerecho: 200);

    final resultado = MotorCombate.resolverColision(personaje, momia);

    expect(resultado, ResultadoColisionMomia.jugadorGolpeado);
    expect(momia.derrotada, false);
  });

  test('chocar de lado mientras se cae (pie bajo la mitad de la momia) NO la derrota', () {
    // velocidadY > 0 pero el pie (y=132) esta bajo la mitad de la momia (116).
    final personaje = Personaje(x: 90, y: 100)..velocidadY = 5;
    final momia = Momia(x: 100, y: 100, limiteIzquierdo: 0, limiteDerecho: 200);

    final resultado = MotorCombate.resolverColision(personaje, momia);

    expect(resultado, ResultadoColisionMomia.jugadorGolpeado);
    expect(momia.derrotada, false);
  });

  test('sin interseccion no pasa nada', () {
    final personaje = Personaje(x: 0, y: 0);
    final momia = Momia(x: 500, y: 500, limiteIzquierdo: 0, limiteDerecho: 600);

    expect(
      MotorCombate.resolverColision(personaje, momia),
      ResultadoColisionMomia.ninguna,
    );
  });
}
