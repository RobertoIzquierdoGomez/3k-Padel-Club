import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressFunction;
  final String text;
  final bool isLoading;
  final bool primary;

  const CustomButton({
    super.key,
    this.onPressFunction,
    required this.text,
    required this.isLoading,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          primary
              ? Color.fromARGB(255, 217, 221, 63)
              : Color.fromARGB(255, 218, 84, 93),
        ),
      ),
      onPressed: isLoading ? null : onPressFunction,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // TEXTO (siempre ocupa espacio)
          Opacity(
            opacity: isLoading ? 0 : 1,
            child: Text(text, style: TextStyle(color: Colors.black)),
          ),

          // LOADER encima
          if (isLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}
