import 'dart:async';

import 'package:flutter/material.dart';

import '../datos/preferencias_puntaje.dart';
import '../logica/estado_juego.dart';
import '../logica/mejor_puntaje.dart';
import '../logica/motor_juego.dart';
import '../logica/niveles.dart';
import 'vidas_hud.dart';

/// Solo traduce el estado de MotorJuego a pixeles.
/// Ninguna colision ni puntaje se decide aqui.
class JuegoScreen extends StatefulWidget {
  final RepositorioPuntaje? repositorio;

  const JuegoScreen({super.key, this.repositorio});

  @override
  State<JuegoScreen> createState() => _JuegoScreenState();
}

class _JuegoScreenState extends State<JuegoScreen> {
  late MotorJuego _motor;
  late final MejorPuntaje _mejorPuntaje;
  Timer? _bucle;
  double _direccion = 0;
  int _indiceNivel = 0;
  int _puntajeBase = 0; // puntaje acumulado al empezar el nivel actual
  int _mejor = 0;

  @override
  void initState() {
    super.initState();
    _mejorPuntaje = MejorPuntaje(widget.repositorio ?? PreferenciasPuntaje());
    _mejorPuntaje.actual().then((valor) {
      if (mounted) setState(() => _mejor = valor);
    });
    _iniciarNivel();
    _iniciarBucle();
  }

  @override
  void dispose() {
    _bucle?.cancel();
    super.dispose();
  }

  void _iniciarNivel() {
    _motor = Niveles.todos[_indiceNivel].crearMotor();
    _motor.puntaje = _puntajeBase;
    _direccion = 0;
  }

  void _iniciarBucle() {
    _bucle = Timer.periodic(const Duration(milliseconds: 16), (_) {
      setState(() => _motor.mover(_direccion * 4));
      if (_motor.estado != EstadoJuego.jugando) {
        _bucle?.cancel();
        _terminarNivel();
      }
    });
  }

  Future<void> _terminarNivel() async {
    final mejor = await _mejorPuntaje.registrar(_motor.puntaje);
    if (!mounted) return;
    setState(() => _mejor = mejor);
    _mostrarResultado();
  }

  void _mostrarResultado() {
    final gano = _motor.estado == EstadoJuego.ganado;
    final hayOtroNivel = _indiceNivel < Niveles.todos.length - 1;
    final textoBoton = gano
        ? (hayOtroNivel ? 'Siguiente nivel' : 'Jugar de nuevo')
        : 'Reintentar';
    final titulo = gano
        ? (hayOtroNivel
            ? 'Nivel superado!'
            : 'Llegaste al Callejón del Beso!')
        : 'Las momias te atraparon';

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'resultado',
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) => ScaleTransition(
        scale: CurvedAnimation(parent: anim1, curve: Curves.elasticOut),
        child: FadeTransition(
          opacity: anim1,
          child: AlertDialog(
            title: Text(titulo),
            content: Text('Puntaje: ${_motor.puntaje}\nMejor: $_mejor'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    if (gano && hayOtroNivel) {
                      _puntajeBase = _motor.puntaje;
                      _indiceNivel++;
                    } else if (gano) {
                      _puntajeBase = 0;
                      _indiceNivel = 0;
                    }
                    _iniciarNivel();
                  });
                  _iniciarBucle();
                },
                child: Text(textoBoton),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const anchoVentana = 360.0;
    final camaraX = (_motor.personaje.x - anchoVentana / 2)
        .clamp(0, _motor.anchoNivel - anchoVentana);

    return Scaffold(
      appBar: AppBar(title: const Text('Momias de Guanajuato')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VidasHud(
                  vidas: _motor.vidas,
                  maximo: MotorJuego.vidasIniciales,
                ),
                Text(Niveles.todos[_indiceNivel].nombre),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Puntaje: ${_motor.puntaje}'),
                    Text('Mejor: $_mejor'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRect(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  ..._motor.plataformas.map(
                    (pl) => Positioned(
                      left: pl.x - camaraX,
                      top: pl.y,
                      child: Container(
                        width: pl.ancho,
                        height: pl.alto,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE91E63),
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  ..._motor.calaveritas.where((c) => !c.recolectada).map(
                        (c) => Positioned(
                          left: c.x - camaraX,
                          top: c.y,
                          child: const Text(
                            '\u{1F480}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                  ..._motor.momias.where((m) => !m.derrotada).map(
                        (m) => Positioned(
                          left: m.x - camaraX,
                          top: m.y,
                          child: Container(
                            width: m.ancho,
                            height: m.alto,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD7CCC8),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black38),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '\u{1F9DF}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                  Positioned(
                    left: _motor.personaje.x - camaraX,
                    top: _motor.personaje.y,
                    child: Container(
                      width: _motor.personaje.ancho,
                      height: _motor.personaje.alto,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '\u{1F920}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _boton(
                      Icons.arrow_back,
                      () => _direccion = -1,
                      () => _direccion = 0,
                    ),
                    const SizedBox(width: 12),
                    _boton(
                      Icons.arrow_forward,
                      () => _direccion = 1,
                      () => _direccion = 0,
                    ),
                  ],
                ),
                _boton(Icons.arrow_upward, () => _motor.saltar(), () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _boton(
    IconData icono,
    VoidCallback alPresionar,
    VoidCallback alSoltar,
  ) {
    return GestureDetector(
      onTapDown: (_) => alPresionar(),
      onTapUp: (_) => alSoltar(),
      onTapCancel: alSoltar,
      child: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.indigo,
        child: Icon(icono, color: Colors.white),
      ),
    );
  }
}
