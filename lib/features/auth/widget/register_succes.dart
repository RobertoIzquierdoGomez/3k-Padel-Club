import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class RegisterSucces extends StatelessWidget {
  final String email;

  const RegisterSucces({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    AppLogger.info("Pantalla RegisterSuccess mostrada", tag: "AUTH_REGISTER");
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 30.0,
      children: [
        Text(
          "Hemos enviado un email de confirmación a: $email",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
        ),
        Text(
          "Revisa tu correo para confirmar tu cuenta y completar tú perfil.",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
        ),
        Text(
          'Sino ves el correo en tu bandeja de entrada revisa en "correo no deseado"',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
        ),
        CustomButton(
          text: "Volver login",
          isLoading: false,
          primary: true,
          onPressFunction: () {
            AppLogger.info('Pulsado "Volver login" desde RegisterSucces', tag: "NAV_AUTH");
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
