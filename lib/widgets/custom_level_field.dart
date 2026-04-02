import 'package:flutter/material.dart';

class CustomLevelField extends StatefulWidget {
  final Function(double) onChanged;

  const CustomLevelField({super.key, required this.onChanged});

  @override
  State<CustomLevelField> createState() => _CustomLevelFieldSate();
}

class _CustomLevelFieldSate extends State<CustomLevelField> {
  double nivel = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Selecciona tú nivel: ${nivel.toStringAsFixed(1)}",
          style: TextStyle(fontSize: 16.0),
        ),
        Slider(
          value: nivel,
          min: 1,
          max: 10,
          divisions: 18, // pasos (0.5)
          label: nivel.toStringAsFixed(1),
          activeColor: Color.fromARGB(255, 45, 68, 151),
          onChanged: (value) {
            setState(() {
              nivel = value;
            });
            widget.onChanged(value);
          },
        ),
      ],
    );
  }
}
