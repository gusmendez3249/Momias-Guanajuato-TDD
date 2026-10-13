import 'package:flutter_test/flutter_test.dart';
import 'package:momias_guanajuato/logica/motor_fisica.dart';
import 'package:momias_guanajuato/logica/personaje.dart';
import 'package:momias_guanajuato/logica/rectangulo.dart';

void main() {
  group('colision lateral con plataformas (reto 1)', () {
    const pared = Rectangulo(x: 100, y: 90, ancho: 50, alto: 40);

    test('al venir desde la izquierda el personaje queda pegado al borde izquierdo', () {
      // x anterior 60 (borde derecho 92 <= 100); tras moverse quedo en 80 (traslapado).
      final personaje = Personaje(x: 80, y: 80);

      MotorFisica.resolverColisionLateral(personaje, [pared], 60);

      expect(personaje.x, 100 - personaje.ancho);
    });

    test('al venir desde la derecha el personaje queda pegado al borde derecho', () {
      final personaje = Personaje(x: 145, y: 80);

      MotorFisica.resolverColisionLateral(personaje, [pared], 152);

      expect(personaje.x, 150);
    });

    test('si el personaje esta por encima de la plataforma no hay empuje lateral', () {
      final personaje = Personaje(x: 120, y: 58); // pie exactamente en y=90

      MotorFisica.resolverColisionLateral(personaje, [pared], 60);

      expect(personaje.x, 120);
    });

    test('si el personaje esta muy por debajo de la plataforma no hay empuje lateral', () {
      final personaje = Personaje(x: 120, y: 200);

      MotorFisica.resolverColisionLateral(personaje, [pared], 60);

      expect(personaje.x, 120);
    });
  });

  group('meta', () {
    test('haLlegadoALaMeta es verdadero cuando el personaje alcanza la posicion', () {
      final personaje = Personaje(x: 1900, y: 0);

      expect(MotorFisica.haLlegadoALaMeta(personaje, 1900), true);
    });

    test('haLlegadoALaMeta es falso si aun no llega', () {
      final personaje = Personaje(x: 500, y: 0);

      expect(MotorFisica.haLlegadoALaMeta(personaje, 1900), false);
    });
  });

  group('movimiento horizontal', () {
    test('moverHorizontal desplaza al personaje segun el delta recibido', () {
      final personaje = Personaje(x: 50, y: 0);

      MotorFisica.moverHorizontal(personaje, 10, 1000);

      expect(personaje.x, 60);
    });

    test('moverHorizontal no deja salir al personaje por el borde izquierdo', () {
      final personaje = Personaje(x: 2, y: 0);

      MotorFisica.moverHorizontal(personaje, -10, 1000);

      expect(personaje.x, 0);
    });

    test('moverHorizontal no deja salir al personaje por el borde derecho', () {
      final personaje = Personaje(x: 990, y: 0);

      MotorFisica.moverHorizontal(personaje, 20, 1000);

      expect(personaje.x, 1000 - personaje.ancho);
    });
  });

  group('colision con el piso', () {
    test('el personaje aterriza sobre una plataforma al caer sobre ella', () {
      // Pie anterior en 97 (<= 100) y pie actual en 102 (>= 100): cruzo la plataforma cayendo.
      final personaje = Personaje(x: 10, y: 70)..velocidadY = 5;
      const plataforma = Rectangulo(x: 0, y: 100, ancho: 100, alto: 20);

      MotorFisica.resolverColisionConPiso(personaje, [plataforma], 65);

      expect(personaje.enElSuelo, true);
      expect(personaje.y, 100 - personaje.alto);
      expect(personaje.velocidadY, 0);
    });

    test('el personaje no aterriza si todavia esta muy por encima de la plataforma', () {
      final personaje = Personaje(x: 10, y: 50)..velocidadY = 5;
      const plataforma = Rectangulo(x: 0, y: 100, ancho: 100, alto: 20);

      MotorFisica.resolverColisionConPiso(personaje, [plataforma], 45);

      expect(personaje.enElSuelo, false);
    });
  });

  group('gravedad y salto', () {
    test('aplicarGravedad aumenta la velocidad vertical y mueve al personaje hacia abajo', () {
      final personaje = Personaje(x: 0, y: 0);

      MotorFisica.aplicarGravedad(personaje);

      expect(personaje.velocidadY, MotorFisica.gravedad);
      expect(personaje.y, MotorFisica.gravedad);
    });

    test('saltar solo funciona si el personaje esta en el suelo', () {
      final personaje = Personaje(x: 0, y: 0)..enElSuelo = true;

      MotorFisica.saltar(personaje);

      expect(personaje.velocidadY, MotorFisica.impulsoSalto);
      expect(personaje.enElSuelo, false);
    });

    test('saltar no hace nada si el personaje ya esta en el aire', () {
      final personaje = Personaje(x: 0, y: 0)..enElSuelo = false;

      MotorFisica.saltar(personaje);

      expect(personaje.velocidadY, 0);
    });
  });
}
