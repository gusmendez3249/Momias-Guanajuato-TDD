import 'momia.dart';
import 'motor_fisica.dart';
import 'personaje.dart';

enum ResultadoColisionMomia { ninguna, momiaDerrotada, jugadorGolpeado }

class MotorCombate {
  /// Caer sobre la mitad superior de la momia la derrota (stomp).
  /// Cualquier otro contacto lastima al jugador.
  static ResultadoColisionMomia resolverColision(
    Personaje personaje,
    Momia momia,
  ) {
    if (momia.derrotada) return ResultadoColisionMomia.ninguna;
    if (!personaje.rectangulo.intersectaCon(momia.rectangulo)) {
      return ResultadoColisionMomia.ninguna;
    }

    final cayendoSobreLaMomia = personaje.velocidadY > 0 &&
        (personaje.y + personaje.alto) <= (momia.y + momia.alto / 2);

    if (cayendoSobreLaMomia) {
      momia.derrotada = true;
      personaje.velocidadY = MotorFisica.impulsoSalto / 2; // rebote
      return ResultadoColisionMomia.momiaDerrotada;
    }

    return ResultadoColisionMomia.jugadorGolpeado;
  }
}
