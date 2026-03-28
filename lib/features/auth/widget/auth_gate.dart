import 'package:app_3k_padel/features/perfil/screens/perfil_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_3k_padel/features/auth/screens/login_screen.dart';


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
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Obtenemos la sesión
        final session = snapshot.data?.session;

        // Si NO hay sesión → Login
        if (session == null) {
          return const LoginScreen();
        }

        // Si hay sesión → Home
        return const PerfilScreen();
      },
    );
  }
}