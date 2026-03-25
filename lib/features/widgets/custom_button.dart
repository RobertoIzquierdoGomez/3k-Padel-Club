import 'package:flutter/material.dart';

class BotonPersonalizado extends StatefulWidget {
  const BotonPersonalizado({super.key});

  @override
  State <BotonPersonalizado> createState() => _BotonPersonalizadoState();
}

class _BotonPersonalizadoState extends State <BotonPersonalizado>{



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Prueba"
      ),
    );
  }

}