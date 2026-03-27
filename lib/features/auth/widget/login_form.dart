import 'package:app_3k_padel/main.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:app_3k_padel/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_3k_padel/features/auth/test_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginState();
}

class _LoginState extends State<LoginForm> {
  final GlobalKey<FormState> _loginForm =
      GlobalKey<FormState>(); //Llave para el formulario del login
  final emailCtrl = TextEditingController(); //Control para el campo del email
  final passwordCtrl =
      TextEditingController(); //Control para el campo de la contraseña
  String? errorMessage; //Mensaje de error para el intento del login.

  //libera memoria de los controladores
  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  //Función que va validar que en el email se rellene uno válido.
  String? Function(String?) validatorEmail = (String? value) {
    if (value == null || value.isEmpty) {
      return 'Introduce un email';
    }
    //TODO detectar "." después del @
    if (!value.contains('@')) {
      return 'Introduce un email válido';
    }
    return null;
  };

  //Validador para asegurar que se introduce alguna contraseña.
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
            spacing: 30.0,
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
                controller: passwordCtrl,
              ),
              if (errorMessage != null && errorMessage!.isNotEmpty)
                Text(errorMessage!, style: TextStyle(color: Colors.red)),
              CustomButton(
                text: "Iniciar sesión",
                onPressFunction: () async {
                  if (_loginForm.currentState?.validate() ?? false) {
                    final String email = emailCtrl.text;
                    final String password = passwordCtrl.text;
                    try {
                      final AuthResponse res = await supabase.auth
                          .signInWithPassword(email: email, password: password);
                      final Session? session = res.session;
                      final User? user = res.user;
                      setState(() {
                        errorMessage = null;
                      });
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => TestScreen()),
                        );
                      }
                    } catch (e) {
                      setState(() {
                        errorMessage = "Email o contraseña incorrecto";
                      });
                    }
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
