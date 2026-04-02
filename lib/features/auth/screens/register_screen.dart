
import 'package:app_3k_padel/features/auth/widget/register_form.dart';
import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen ({super.key});


  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Fondo(imagePath: "assets/backgrounds/fondo_registro.png", child: RegisterForm()),
    );
  }
}