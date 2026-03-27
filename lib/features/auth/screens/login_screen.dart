import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:app_3k_padel/features/auth/widget/login_form.dart';
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
        child: Column(
          children: [
            Image(
                  image: AssetImage('assets/logo/3k _logo.PNG'),
                  width: 200,
                ),
            LoginForm(),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 40,
              children: [
                Image(image: AssetImage('assets/logo/haltera.png'), width: 80),
                Image(image: AssetImage('assets/logo/is vet.jpeg'), width: 80),
                Image(image: AssetImage('assets/logo/orto-nipace.jpg'), width: 80),
                Image(image: AssetImage('assets/logo/oyma.png'), width: 80),
                Image(image: AssetImage('assets/logo/stihl.png'), width: 80),
              ],
            ),
          ],
        ),
      ),
    );
  }
}