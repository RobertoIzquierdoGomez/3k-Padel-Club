import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/main.dart';
import 'package:app_3k_padel/services/auth_service.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:app_3k_padel/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecoverPasswordDialog extends StatefulWidget {
  final String initialEmail;

  const RecoverPasswordDialog({
    super.key,
    required this.initialEmail,
  });

  @override
  State<RecoverPasswordDialog> createState() =>
      _RecoverPasswordDialogState();
}

class _RecoverPasswordDialogState extends State<RecoverPasswordDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController emailCtrl;
  final otpCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final repeatPasswordCtrl = TextEditingController();

  int step = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    AppLogger.info("Inicio flujo recuperación contraseña", tag: "AUTH_RECOVERY");
    emailCtrl = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    otpCtrl.dispose();
    newPasswordCtrl.dispose();
    repeatPasswordCtrl.dispose();
    super.dispose();
  }

  String? validatorEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Introduce un email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Introduce un email válido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Recuperar contraseña"),
      content: Form(
        key: formKey,
        child: step == 1
            ? CustomFormField(
                labelText: "Email",
                validator: validatorEmail,
                controller: emailCtrl,
              )
            : step == 2
                ? CustomFormField(
                    labelText: "Código",
                    controller: otpCtrl,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomFormField(
                        labelText: "Nueva contraseña",
                        obscureText: true,
                        controller: newPasswordCtrl,
                      ),
                      const SizedBox(height: 10),
                      CustomFormField(
                        labelText: "Repite contraseña",
                        obscureText: true,
                        controller: repeatPasswordCtrl,
                      ),
                    ],
                  ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        CustomButton(
          text: "Cancelar",
          isLoading: false,
          primary: false,
          onPressFunction: () async {
            AppLogger.info("Pulsado cancelar", tag: "NAV");
            isRecoveringPassword = false;
            await supabase.auth.signOut();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
        CustomButton(
          text: step == 1
              ? "Enviar código"
              : step == 2
                  ? "Verificar código"
                  : "Cambiar contraseña",
          isLoading: isLoading,
          primary: true,
          onPressFunction: _handleAction,
        ),
      ],
    );
  }

  Future<void> _handleAction() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);

    try {
      if (step == 1) {
        AppLogger.info("Step 1: Enviar código", tag: "AUTH_RECOVERY");
        await AuthService().sendOtpEmail(emailCtrl.text);
        if (!mounted) return;
        setState(() => step = 2);
        AppLogger.info("Step 1: Código enviado correctamente → pasando al Step 2", tag: "AUTH_RECOVERY");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Código enviado')),
        );
      } else if (step == 2) {
        AppLogger.info("Step 2: Verificando OTP", tag: "AUTH_RECOVERY");
        await supabase.auth.verifyOTP(
          email: emailCtrl.text,
          token: otpCtrl.text,
          type: OtpType.email,
        );
        if (!mounted) return;
        setState(() => step = 3);
        AppLogger.info("Step 2: OTP verificado → pasando a Step 3", tag: "AUTH_RECOVERY");
      } else if (step == 3) {
        final password = newPasswordCtrl.text.trim();
        final repeatPassword = repeatPasswordCtrl.text;
        final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');

        if (password.isEmpty) {
          throw Exception ('Introduce una contraseña');
        }

        if (!passwordRegex.hasMatch(password)) {
          throw Exception ('Debe tener mayúsculas, minúsculas y números');
        }

        if (password != repeatPassword) {
          throw Exception("Las contraseñas no coinciden");
        }
        AppLogger.info("Step 3: realizando cambio de contraseña", tag: "AUTH_RECOVERY");
        await supabase.auth.updateUser(
          UserAttributes(password: password),
        );
        await supabase.auth.signOut();
        AppLogger.info("Contraseña actualizada y sesión cerrada", tag: "AUTH_RECOVERY");

        isRecoveringPassword = false;
        if (!mounted) return;
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña actualizada'),
          ),
        );
      }
    } on AuthException catch (e) {
      AppLogger.error("Error en recuperación contraseña: ${e.message}", tag: "AUTH");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      AppLogger.error("Error inesperado en recuperación contraseña: $e", tag: "AUTH");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}