import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:app_3k_padel/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginState();
}

class _LoginState extends State<LoginForm> {
  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();


  @override
  void dispose(){
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  String? Function(String?) validatorEmail = (String? value) {
    if (value == null || value.isEmpty) {
      return 'Introduce un email';
    }
    if (!value.contains('@')) {
      return 'Introduce un email válido';
    }
    return null;
  };

  String? Function(String?) validatorPass = (String? value) {
    if (value == null || value.isEmpty) {
      return 'Introduce una contraseña';
    }
    return null;
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromARGB(255, 217, 221, 63),
            width: 3.0,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        margin: EdgeInsets.all(40),
        padding: EdgeInsets.all(50),
        child: Form(
          key: _loginForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 40.0,
            children: [
              Text(
                "Inicia sesión",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
              ),
              CustomFormField(
                  labelText: "Email",
                  validator: validatorEmail,
                  controller: emailCtrl,
                ),
              CustomFormField(
                labelText: "Contraseña",
                validator: validatorPass,
                obscureText: true,
                controller: passwordCtrl
              ),
              CustomButton(
                onPressFunction: () {
                  if (_loginForm.currentState?.validate() ?? false) {
                    // Process data.
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
