import 'package:app_3k_padel/core/utils/app_logger.dart';
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
    AppLogger.info("Mostrando pantalla de cambio de contraseña", tag: "NAV");
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
      AppLogger.warning("Sesión no disponible o enlace inválido", tag: "AUTH_CHANGE_PASS");
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
        AppLogger.info("Cambio de contraseña completado → mostrando success", tag: "AUTH_CHANGE_PASS");
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
    AppLogger.info("Comprobando sesión del usuario", tag: "AUTH_CHANGE_PASS");
    await Future.delayed(const Duration(milliseconds: 500));
    final Session? session = supabase.auth.currentSession;
    AppLogger.info("Sesión ${session != null ? "válida" : "no disponible"}", tag: "AUTH_CHANGE_PASS");
    setState(() {
      hasSession = session != null;
      isLoading = false;
    });
  }
}