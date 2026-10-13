import 'package:flutter/material.dart';

/// Reto 2: vidas como corazones (llenos = vidas restantes, vacios = perdidas).
class VidasHud extends StatelessWidget {
  final int vidas;
  final int maximo;

  const VidasHud({super.key, required this.vidas, required this.maximo});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < maximo; i++)
          Icon(
            i < vidas ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
            size: 22,
          ),
      ],
    );
  }
}
