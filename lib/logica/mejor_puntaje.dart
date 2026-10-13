/// Costura para persistir el record: en pruebas se usa una version en memoria,
/// en la app real `PreferenciasPuntaje` (shared_preferences).
abstract class RepositorioPuntaje {
  Future<int> leer();
  Future<void> guardar(int puntaje);
}

class MejorPuntaje {
  final RepositorioPuntaje repositorio;

  MejorPuntaje(this.repositorio);

  Future<int> actual() => repositorio.leer();

  /// Guarda el puntaje solo si supera el record y devuelve el mejor puntaje.
  Future<int> registrar(int puntaje) async {
    final record = await repositorio.leer();
    if (puntaje > record) {
      await repositorio.guardar(puntaje);
      return puntaje;
    }
    return record;
  }
}
