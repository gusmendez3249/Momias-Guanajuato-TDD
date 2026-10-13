class Rectangulo {
  final double x, y, ancho, alto;

  const Rectangulo({
    required this.x,
    required this.y,
    required this.ancho,
    required this.alto,
  });

  /// Colision AABB: dos rectangulos se traslapan si se traslapan
  /// en el eje X y en el eje Y al mismo tiempo.
  bool intersectaCon(Rectangulo otro) {
    return x < otro.x + otro.ancho &&
        x + ancho > otro.x &&
        y < otro.y + otro.alto &&
        y + alto > otro.y;
  }
}
