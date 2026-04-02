import 'package:app_3k_padel/features/auth/widget/register_succes.dart';
import 'package:app_3k_padel/main.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:app_3k_padel/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _registerForm = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrol = TextEditingController();
  bool isLoading = false;
  bool registerSuccess = false;

  String? errorMessage;

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
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'Introduce una contraseña';
    }

    if (value.length < 8) {
      return 'La contraseña tiene que tener al menos 8 carácteres';
    }

    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return 'Debe tener mayúsculas, minúsculas y números';
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
        child: !registerSuccess ? 
        Form(
          key: _registerForm,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30.0,
            children: [
              CustomFormField(
                labelText: "email",
                controller: emailCtrl,
                validator: validatorEmail,
              ),
              CustomFormField(
                labelText: "contraseña",
                controller: passCtrol,
                validator: validatorPass,
                obscureText: true,
              ),
              Text(
                "Mín. 8 caracteres, mayúscula, minúscula y número",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),
              ),
              if (errorMessage != null && errorMessage!.isNotEmpty)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              CustomButton(
                text: "Finalizar registro",
                isLoading: isLoading,
                primary: true,
                onPressFunction: _RegisterUser,
              ),
            ],
          )
        ) : RegisterSucces(email: emailCtrl.text)
      ),
    );
  }

  Future<void> _RegisterUser() async {
    if (_registerForm.currentState?.validate() ?? false) {
      setState(() {
        errorMessage = null;
        isLoading = true;
      });

      final String email = emailCtrl.text;
      final String pass = passCtrol.text;

      try {
        final AuthResponse res = await supabase.auth.signUp(
          email: email,
          password: pass,
        );
        final User? user = res.user;

        if(user != null){
          setState(() {
            registerSuccess = true;
          });
        }
      } on AuthException catch (e) {
        setState(() {
          errorMessage = "Error al hacer el registro: $e";
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