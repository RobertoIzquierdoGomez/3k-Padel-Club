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
            isRecoveringPassword = false;
            await supabase.auth.signOut();
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
        await AuthService().sendOtpEmail(emailCtrl.text);

        setState(() => step = 2);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Código enviado')),
        );
      } else if (step == 2) {
        await supabase.auth.verifyOTP(
          email: emailCtrl.text,
          token: otpCtrl.text,
          type: OtpType.email,
        );

        setState(() => step = 3);
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

        await supabase.auth.updateUser(
          UserAttributes(password: password),
        );

        await supabase.auth.signOut();

        isRecoveringPassword = false;

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña actualizada'),
          ),
        );
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}