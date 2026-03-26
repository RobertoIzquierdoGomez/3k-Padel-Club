import 'package:app_3k_padel/features/widgets/custom_background.dart';
import 'package:app_3k_padel/features/widgets/login_form.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Fondo(
        imagePath: 'assets/backgrounds/fondo_login.jpg',
        child: LoginForm(),
      ),
    );
  }
}
