import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget{
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginState();
}

class _LoginState extends State<LoginForm>{
  @override
  Widget build(BuildContext context){
    return Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 500, maxHeight: 300),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              margin: EdgeInsets.all(40),
              child: Center(child: Text("Prueba")),
            ),
          );
  }
}
