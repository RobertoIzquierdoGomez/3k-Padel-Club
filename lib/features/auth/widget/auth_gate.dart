import 'package:app_3k_padel/features/perfil/screens/complete_profile_screen.dart';
import 'package:app_3k_padel/services/user_service.dart';
import 'package:app_3k_padel/test_screen.dart';
import 'package:app_3k_padel/features/perfil/screens/profile_screen.dart';
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
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Obtenemos la sesión
        final session = snapshot.data?.session;

        // Si NO hay sesión → Login
        if (session == null) {
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
              return Text(snapshot.error.toString());
            }
            //Cuando ya terminó
            final usuario = snapshot.data;
            if (usuario == null) {
              return const LoginScreen();
            }

            if(!usuario.perfilCompleto){
              return const CompleteProfileScreen();
            }
            return const PerfilScreen();
          },
        );
      },
    );
  }
}
