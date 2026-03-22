import 'package:app_3k_padel/features/widgets/boton_personalizado.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  String texto = "Prueba";

  void pulsar() {
    setState(() {
      texto = "Pulsado el botón";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image(image: AssetImage('assets/backgrounds/grupo_personas_padel.png')),
          
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                color: Colors.white,
              ),
              margin: EdgeInsets.all(30),
              height: 300,
              child: Center(child: Text("Prueba")),
            ),
          ),
        ],
      ),
    );
  }
}
