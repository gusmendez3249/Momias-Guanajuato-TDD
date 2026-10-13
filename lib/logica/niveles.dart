import 'calaverita.dart';
import 'momia.dart';
import 'motor_juego.dart';
import 'personaje.dart';
import 'rectangulo.dart';

/// Un nivel es solo datos + una fabrica: ambos niveles reutilizan
/// exactamente el mismo MotorJuego.
class Nivel {
  final String nombre;
  final MotorJuego Function() crearMotor;

  const Nivel({required this.nombre, required this.crearMotor});
}

class Niveles {
  static final List<Nivel> todos = [
    Nivel(nombre: 'Nivel 1', crearMotor: _nivel1),
    Nivel(nombre: 'Nivel 2', crearMotor: _nivel2),
  ];

  static MotorJuego _nivel1() => MotorJuego(
        personaje: Personaje(x: 20, y: 100),
        plataformas: const [
          Rectangulo(x: 0, y: 300, ancho: 2000, alto: 40),
          Rectangulo(x: 300, y: 220, ancho: 120, alto: 20),
          Rectangulo(x: 550, y: 160, ancho: 120, alto: 20),
        ],
        momias: [
          Momia(x: 320, y: 268, limiteIzquierdo: 300, limiteDerecho: 420),
          Momia(x: 900, y: 268, limiteIzquierdo: 850, limiteDerecho: 1100),
        ],
        calaveritas: [
          Calaverita(x: 360, y: 180),
          Calaverita(x: 600, y: 120),
          Calaverita(x: 1200, y: 260),
        ],
        posicionMeta: 1900,
        anchoNivel: 2000,
      );

  /// Mas largo: pared que obliga a saltar (reto 1), momia vertical (reto 3)
  /// y mas plataformas, momias y calaveritas.
  static MotorJuego _nivel2() => MotorJuego(
        personaje: Personaje(x: 20, y: 100),
        plataformas: const [
          Rectangulo(x: 0, y: 300, ancho: 3000, alto: 40),
          Rectangulo(x: 250, y: 230, ancho: 100, alto: 20),
          Rectangulo(x: 450, y: 170, ancho: 100, alto: 20),
          Rectangulo(x: 700, y: 230, ancho: 120, alto: 20),
          Rectangulo(x: 1300, y: 220, ancho: 120, alto: 20),
          Rectangulo(x: 1800, y: 240, ancho: 30, alto: 60), // pared
          Rectangulo(x: 2300, y: 200, ancho: 150, alto: 20),
        ],
        momias: [
          Momia(x: 600, y: 268, limiteIzquierdo: 560, limiteDerecho: 700),
          Momia(x: 1000, y: 268, limiteIzquierdo: 950, limiteDerecho: 1150),
          Momia.vertical(x: 1500, y: 200, limiteArriba: 150, limiteAbajo: 300),
          Momia(x: 2100, y: 268, limiteIzquierdo: 2050, limiteDerecho: 2250),
          Momia(x: 2600, y: 268, limiteIzquierdo: 2500, limiteDerecho: 2700),
        ],
        calaveritas: [
          Calaverita(x: 290, y: 190),
          Calaverita(x: 490, y: 130),
          Calaverita(x: 740, y: 190),
          Calaverita(x: 1340, y: 180),
          Calaverita(x: 2340, y: 160),
          Calaverita(x: 2800, y: 260),
        ],
        posicionMeta: 2900,
        anchoNivel: 3000,
      );
}
