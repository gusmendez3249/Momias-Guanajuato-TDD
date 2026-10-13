import 'calaverita.dart';
import 'estado_juego.dart';
import 'momia.dart';
import 'motor_combate.dart';
import 'motor_fisica.dart';
import 'personaje.dart';
import 'rectangulo.dart';

class MotorJuego {
  final Personaje personaje;
  final List<Rectangulo> plataformas;
  final List<Momia> momias;
  final List<Calaverita> calaveritas;
  final double posicionMeta;
  final double anchoNivel;

  int vidas = 3;
  int puntaje = 0;
  EstadoJuego estado = EstadoJuego.jugando;

  final double _xInicial;
  final double _yInicial;

  static const int puntosPorCalaverita = 50;

  MotorJuego({
    required this.personaje,
    required this.plataformas,
    required this.momias,
    required this.calaveritas,
    required this.posicionMeta,
    required this.anchoNivel,
  })  : _xInicial = personaje.x,
        _yInicial = personaje.y;

  void saltar() => MotorFisica.saltar(personaje);

  /// Unico lugar que decide el orden de las reglas:
  /// fisica -> piso -> momias/combate -> calaveritas -> meta.
  void mover(double deltaX) {
    if (estado != EstadoJuego.jugando) return;

    final yAnterior = personaje.y;
    MotorFisica.moverHorizontal(personaje, deltaX, anchoNivel);
    MotorFisica.aplicarGravedad(personaje);
    MotorFisica.resolverColisionConPiso(personaje, plataformas, yAnterior);

    for (final momia in momias) {
      momia.patrullar();
      final resultado = MotorCombate.resolverColision(personaje, momia);
      if (resultado == ResultadoColisionMomia.jugadorGolpeado) {
        _perderVida();
        return;
      }
    }

    puntaje += recolectarSiCorresponde(personaje, calaveritas);

    if (MotorFisica.haLlegadoALaMeta(personaje, posicionMeta)) {
      estado = EstadoJuego.ganado;
    }
  }

  void _perderVida() {
    vidas--;
    if (vidas <= 0) {
      estado = EstadoJuego.perdido;
    } else {
      personaje.x = _xInicial;
      personaje.y = _yInicial;
      personaje.velocidadY = 0;
    }
  }

  static int recolectarSiCorresponde(
    Personaje personaje,
    List<Calaverita> calaveritas,
  ) {
    var puntos = 0;
    for (final c in calaveritas) {
      if (!c.recolectada && personaje.rectangulo.intersectaCon(c.rectangulo)) {
        c.recolectada = true;
        puntos += puntosPorCalaverita;
      }
    }
    return puntos;
  }
}
