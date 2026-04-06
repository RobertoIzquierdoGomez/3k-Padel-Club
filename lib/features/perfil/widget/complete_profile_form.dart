import 'package:app_3k_padel/core/utils/app_logger.dart';
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

  String? errorMessage;

  String? Function(String?) validatorNombre = (String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'Introduce un nombre';
    }
    return null;
  };

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

  Future<void> _updateUser() async {
    AppLogger.info("Intento de completar perfil", tag: "AUTH_PROFILE");

    if (_completeProfileForm.currentState?.validate() ?? false) {
      AppLogger.info("Formulario de completar perfil válido", tag: "AUTH_PROFILE");

      setState(() {
        errorMessage = null;
        isLoading = true;
      });

      final String nombre = nombreCtrl.text;
      final String apellidos = apellidosCtrl.text;

      try {
        AppLogger.info("Actualizando datos de perfil", tag: "AUTH_PROFILE");

        await UserService().updateProfile(
          supabase.auth.currentUser!.id,
          nombre,
          apellidos,
          nivel,
        );

        AppLogger.info("Perfil actualizado correctamente", tag: "AUTH_PROFILE");
        if(!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthGate()),
          (route) => false,
        );
      } catch (e) {
        AppLogger.error("Error actualizando perfil: $e", tag: "AUTH_PROFILE");

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
    } else {
      AppLogger.warning("Formulario de completar perfil inválido", tag: "AUTH_PROFILE");
    }
  }
}