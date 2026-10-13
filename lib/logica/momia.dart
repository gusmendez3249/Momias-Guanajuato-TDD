import 'rectangulo.dart';

class Momia {
  double x;
  double y;
  final double ancho = 32;
  final double alto = 32;
  double velocidadX;
  double velocidadY;
  final double limiteIzquierdo;
  final double limiteDerecho;
  final double? limiteArriba;
  final double? limiteAbajo;
  bool derrotada = false;

  /// Momia horizontal: patrulla entre limiteIzquierdo y limiteDerecho.
  Momia({
    required this.x,
    required this.y,
    required this.limiteIzquierdo,
    required this.limiteDerecho,
    this.velocidadX = 2,
  })  : velocidadY = 0,
        limiteArriba = null,
        limiteAbajo = null;

  /// Momia vertical (reto 3): misma clase, patrulla entre limiteArriba y
  /// limiteAbajo y no se mueve en horizontal.
  Momia.vertical({
    required this.x,
    required this.y,
    required double this.limiteArriba,
    required double this.limiteAbajo,
    this.velocidadY = 2,
  })  : velocidadX = 0,
        limiteIzquierdo = x,
        limiteDerecho = x + 32;

  Rectangulo get rectangulo =>
      Rectangulo(x: x, y: y, ancho: ancho, alto: alto);

  /// Patrullaje de ida y vuelta entre dos limites fijos.
  void patrullar() {
    if (derrotada) return;

    if (velocidadX != 0) _patrullarHorizontal();
    if (velocidadY != 0) _patrullarVertical();
  }

  void _patrullarHorizontal() {
    x += velocidadX;
    if (x <= limiteIzquierdo) {
      x = limiteIzquierdo;
      velocidadX = velocidadX.abs();
    } else if (x + ancho >= limiteDerecho) {
      x = limiteDerecho - ancho;
      velocidadX = -velocidadX.abs();
    }
  }

  void _patrullarVertical() {
    final arriba = limiteArriba;
    final abajo = limiteAbajo;
    if (arriba == null || abajo == null) return;

    y += velocidadY;
    if (y <= arriba) {
      y = arriba;
      velocidadY = velocidadY.abs();
    } else if (y + alto >= abajo) {
      y = abajo - alto;
      velocidadY = -velocidadY.abs();
    }
  }
}
