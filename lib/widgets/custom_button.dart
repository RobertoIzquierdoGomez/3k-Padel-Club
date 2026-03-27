import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressFunction;

  const CustomButton({super.key, this.onPressFunction});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          Color.fromARGB(255, 217, 221, 63),
        ),
      ),
      onPressed: onPressFunction,
      child: const Text("Prueba"),
    );
  }
}
