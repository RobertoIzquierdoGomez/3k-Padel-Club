import 'package:app_3k_padel/features/auth/widget/auth_gate.dart';
import 'package:app_3k_padel/main.dart';
import 'package:app_3k_padel/services/user_service.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:app_3k_padel/widgets/custom_form_field.dart';
import 'package:app_3k_padel/widgets/custom_level_field.dart';
import 'package:flutter/material.dart';

class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({super.key});

  @override
  State<CompleteProfileForm> createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final GlobalKey<FormState> _completeProfileForm = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  final apellidosCtrl = TextEditingController();
  bool isLoading = false;
  double nivel = 1;

  String? errorMessage; //Mensaje de error para el intento del login.

  //Validador para asegurar que se introduce algún nombre
  String? Function(String?) validatorNombre = (String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'Introduce un nombre';
    }
    return null;
  };

  //Validador para asegurar que se introduce algún apellido
  String? Function(String?) validatorApellidos = (String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'Introduce un apellido';
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
          key: _completeProfileForm,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30.0,
            children: [
              Text(
                "Información de perfil",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
              ),
              CustomFormField(
                labelText: "Nombre",
                controller: nombreCtrl,
                validator: validatorNombre,
              ),
              CustomFormField(
                labelText: "Apellidos",
                controller: apellidosCtrl,
                validator: validatorApellidos,
              ),
              CustomLevelField(
                onChanged: (value) {
                  nivel = value;
                },
              ),
              if (errorMessage != null && errorMessage!.isNotEmpty)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              CustomButton(
                text: "Registrar",
                isLoading: isLoading,
                primary: true,
                onPressFunction: _updateUser,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Función para actualizar el usuario
  Future<void> _updateUser() async {
    if (_completeProfileForm.currentState?.validate() ?? false) {
      setState(() {
        errorMessage = null;
        isLoading = true;
      });
      final String nombre = nombreCtrl.text;
      final String apellidos = apellidosCtrl.text;

      try {
        await UserService().updateProfile(
          supabase.auth.currentUser!.id,
          nombre,
          apellidos,
          nivel,
        );

        //Navigator manual fuerza la recarga manual del AuthGate. Esto evita que se quede en la pantalla de completar perfil una vez ya completado.
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthGate()),
          (route) => false,
        );
      } catch (e) {
        setState(() {
          errorMessage = "Error al guardar el usuario";
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
