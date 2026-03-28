import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressFunction;
  final String text;
  final bool isLoading;

  const CustomButton({
    super.key,
    this.onPressFunction,
    required this.text,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          Color.fromARGB(255, 217, 221, 63),
        ),
      ),
      onPressed: isLoading ? null : onPressFunction,
      child: isLoading
          ? Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              ),
            )
          : Text(text, style: TextStyle(color: Colors.black)),
    );
  }
}
