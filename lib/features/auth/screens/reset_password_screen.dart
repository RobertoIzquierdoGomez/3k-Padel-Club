import 'package:app_3k_padel/features/auth/widget/reset_password_form.dart';
import 'package:app_3k_padel/features/auth/widget/reset_password_success.dart';
import 'package:app_3k_padel/main.dart';
import 'package:app_3k_padel/widgets/custom_background.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool isLoading = true;
  bool hasSession = false;
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentChild;

    if (isLoading) {
      currentChild = Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
        ),
      );
    } else if (!hasSession) {
      currentChild = Center(
        child: Text("Enlace inválido o sesión no disponible"),
      );
    } else if (isSuccess) {
      currentChild = ResetPasswordSuccess(isRecovery: true);
    } else {
      currentChild = ResetPasswordForm(onSuccess: () {
        setState(() {
          isSuccess = true;
        });
      },);
    }

    return Scaffold(
      body: Fondo(
        imagePath: "assets/backgrounds/fondo_cambio_contraseña.png",
        child: currentChild,
      ),
    );
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final Session? session = supabase.auth.currentSession;
    setState(() {
      hasSession = session != null;
      isLoading = false;
    });
  }
}