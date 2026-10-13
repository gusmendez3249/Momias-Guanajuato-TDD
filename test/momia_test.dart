import 'package:flutter_test/flutter_test.dart';
import 'package:momias_guanajuato/logica/momia.dart';

void main() {
  test('la momia avanza en linea recta mientras no llegue a un limite', () {
    final momia = Momia(
      x: 100,
      y: 0,
      limiteIzquierdo: 50,
      limiteDerecho: 200,
      velocidadX: 2,
    );

    momia.patrullar();

    expect(momia.x, 102);
  });

  test('la momia invierte direccion al llegar al limite derecho', () {
    final momia = Momia(
      x: 165,
      y: 0,
      limiteIzquierdo: 50,
      limiteDerecho: 200,
      velocidadX: 2,
    );

    momia.patrullar(); // x=167, borde derecho 199: aun no llega a 200
    momia.patrullar(); // x=169, borde derecho 201: ya paso el limite

    expect(momia.velocidadX, -2);
  });

  group('momia vertical (reto 3)', () {
    test('la momia vertical sube y baja sin moverse en horizontal', () {
      final momia = Momia.vertical(
        x: 300,
        y: 100,
        limiteArriba: 50,
        limiteAbajo: 200,
        velocidadY: 2,
      );

      momia.patrullar();

      expect(momia.y, 102);
      expect(momia.x, 300);
    });

    test('la momia vertical invierte direccion al llegar al limite inferior', () {
      final momia = Momia.vertical(
        x: 300,
        y: 165,
        limiteArriba: 50,
        limiteAbajo: 200,
        velocidadY: 2,
      );

      momia.patrullar(); // y=167, borde inferior 199: aun no llega
      momia.patrullar(); // y=169, borde inferior 201: paso el limite

      expect(momia.velocidadY, -2);
      expect(momia.y, 168);
    });

    test('la momia vertical invierte direccion al llegar al limite superior', () {
      final momia = Momia.vertical(
        x: 300,
        y: 51,
        limiteArriba: 50,
        limiteAbajo: 200,
        velocidadY: -2,
      );

      momia.patrullar(); // y=49, paso el limite

      expect(momia.velocidadY, 2);
      expect(momia.y, 50);
    });

    test('una momia vertical derrotada no se mueve', () {
      final momia = Momia.vertical(x: 300, y: 100, limiteArriba: 50, limiteAbajo: 200)
        ..derrotada = true;

      momia.patrullar();

      expect(momia.y, 100);
    });

    test('la momia horizontal no se mueve en vertical', () {
      final momia = Momia(x: 100, y: 40, limiteIzquierdo: 50, limiteDerecho: 200);

      momia.patrullar();

      expect(momia.y, 40);
    });
  });

  test('una momia derrotada no se mueve', () {
    final momia = Momia(
      x: 100,
      y: 0,
      limiteIzquierdo: 50,
      limiteDerecho: 200,
    )..derrotada = true;

    momia.patrullar();

    expect(momia.x, 100);
  });
}
