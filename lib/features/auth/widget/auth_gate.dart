import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/features/home/screens/home_screen.dart';
import 'package:app_3k_padel/features/perfil/screens/complete_profile_screen.dart';
import 'package:app_3k_padel/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_3k_padel/features/auth/screens/login_screen.dart';
import 'package:app_3k_padel/main.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      // Escuchamos los cambios de autenticación
      stream: Supabase.instance.client.auth.onAuthStateChange,

      builder: (context, snapshot) {
        // Mientras está cargando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Obtenemos la sesión
        final session = snapshot.data?.session;

        // Si NO hay sesión → Login
        if (session == null || isRecoveringPassword) {
          AppLogger.info("No hay sesión o está recuperando contraseña, mostrando login", tag: "NAV_GATE");
          return const LoginScreen();
        }

        return FutureBuilder(
          future: UserService().getCurrentUser(),
          builder: (context, snapshot) {
            //Mientras está cargando
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: SizedBox());
            }
            //Si hay error
            if (snapshot.hasError) {
              AppLogger.error("Error cargando usuario: ${snapshot.error}", tag: "AUTH_GATE");
              return Text(snapshot.error.toString());
            }
            //Cuando ya terminó
            final usuario = snapshot.data;
            if (usuario == null) {
              AppLogger.info("Usuario cargado null, mostrando inicio de sesión", tag: "AUTH_GATE");
              return const LoginScreen();
            }

            if(!usuario.perfilCompleto){
              AppLogger.info("Usuario cargado, pendiente completar perfil. Mostrando CompleteProfileScreen", tag: "AUTH_GATE");
              return const CompleteProfileScreen();
            }

            AppLogger.info("Usuario cargado correctamente. Mostrando HomeScreen", tag: "AUTH_GATE");
            return const HomeScreen();
          },
        );
      },
    );
  }
}