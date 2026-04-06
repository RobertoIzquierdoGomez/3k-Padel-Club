import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/services/auth_service.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:app_3k_padel/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordForm extends StatefulWidget {

  final Function onSuccess;

  const ResetPasswordForm({super.key, required this.onSuccess});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final GlobalKey<FormState> _resetPasswordForm = GlobalKey<FormState>();
  final passwordCtrl = TextEditingController();
  final repeatPasswordCtrl = TextEditingController();
  String? errorMessage;
  bool isLoading = false;

  String? Function(String?) validatorNewPass = (String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'Introduce una contraseña';
    }

    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return 'Debe tener mayúsculas, minúsculas y números';
    }

    return null;
  };

  String? validatorRepeatPass(String? value) {
    if (value == null || value.isEmpty) {
      return 'Introduce una contraseña';
    }

    if (value != passwordCtrl.text) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

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
          key: _resetPasswordForm,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30.0,
            children: [
              Text(
                "Nueva contraseña",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
              ),
              Text(
                "Mín. 8 caracteres, mayúscula, minúscula y número",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),
              ),
              CustomFormField(
                labelText: "Nueva contraseña",
                validator: validatorNewPass,
                controller: passwordCtrl,
                obscureText: true,
              ),
              CustomFormField(
                labelText: "Repite contraseña",
                validator: validatorRepeatPass,
                controller: repeatPasswordCtrl,
                obscureText: true,
              ),
              if (errorMessage != null && errorMessage!.isNotEmpty)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              CustomButton(
                text: "Cambiar contraseña",
                isLoading: isLoading,
                primary: true,
                onPressFunction: _updatePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updatePassword() async {
    AppLogger.info("Pulsado cambio de contraseña", tag: "AUTH_CHANGE_PASS");
    if (_resetPasswordForm.currentState?.validate() ?? false) {
      AppLogger.info("Formulario de cambio de contraseña correcto", tag: "AUTH_CHANGE_PASS");
      setState(() {
        errorMessage = null;
        isLoading = true;
      });

      final String password = passwordCtrl.text;

      try {
        AppLogger.info("Ejecutando cambio de contraseña", tag: "AUTH_CHANGE_PASS");
        await AuthService().updatePassword(password);
        passwordCtrl.clear();
        repeatPasswordCtrl.clear();
        AppLogger.info("Cambio de contraseña ejecutado correctamente", tag: "AUTH_CHANGE_PASS");
        widget.onSuccess();

      } on AuthException catch (e) {
        AppLogger.error("Error cambiando contraseña: ${e.message}", tag: "AUTH_CHANGE_PASS");
        setState(() {
          errorMessage = e.message;
        });
      } catch (e) {
        AppLogger.error("Error inesperado al cambiar contraseña: $e", tag: "AUTH_CHANGE_PASS");
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
    } else {
      AppLogger.warning("Formulario de cambio de contraseña inválido", tag: "AUTH_CHANGE_PASS");
    }
  }
}
