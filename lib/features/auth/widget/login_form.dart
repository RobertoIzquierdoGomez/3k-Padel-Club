import 'package:app_3k_padel/features/auth/screens/register_screen.dart';
import 'package:app_3k_padel/services/auth_service.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:app_3k_padel/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  bool isLoading = false; //Control del botón



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

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
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
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 500;

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
        margin: EdgeInsets.all(isMobile ? 16 : 40),
        padding: EdgeInsets.all(isMobile ? 24 : 50),
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
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              isMobile
                  ? Column(
                      children: [
                        CustomButton(
                          text: "Iniciar sesión",
                          isLoading: isLoading,
                          primary: true,
                          onPressFunction: _login,
                        ),
                        SizedBox(height: 15),
                        CustomButton(
                          text: "Registrarme",
                          isLoading: isLoading,
                          primary: false,
                          onPressFunction: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        SizedBox(
                          width: 150,
                          child: CustomButton(
                            text: "Iniciar sesión",
                            isLoading: isLoading,
                            primary: true,
                            onPressFunction: _login,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: CustomButton(
                            text: "Registrarme",
                            isLoading: isLoading,
                            primary: false,
                            onPressFunction: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ),
                              );
                              _loginForm.currentState?.reset();
                              emailCtrl.clear();
                              passwordCtrl.clear();

                              setState(() {
                                errorMessage = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  //Función para hacer login
  Future<void> _login() async {
  if (_loginForm.currentState?.validate() ?? false) {
    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    final String email = emailCtrl.text;
    final String password = passwordCtrl.text;

    try {
      await AuthService().login(email, password);
    } on AuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });

    } catch (e) {
      setState(() {
        errorMessage = "Error inesperado";
      });

    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
}
