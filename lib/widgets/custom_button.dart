import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressFunction;
  final String text;

  const CustomButton({super.key, this.onPressFunction, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          Color.fromARGB(255, 217, 221, 63),
        ),
      ),
      onPressed: onPressFunction,
      child: Text(text, style: TextStyle(color: Colors.black)),
    );
  }
}
