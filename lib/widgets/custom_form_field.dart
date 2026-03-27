
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final bool? obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomFormField({super.key, required this.labelText, this.hintText, this.validator, this.obscureText, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 45, 68, 151),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 45, 68, 151),
            width: 2.0,
          ),
        ),
        labelText: labelText,
        hintText: hintText,
      ),
      obscureText: obscureText ?? false,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }
}
