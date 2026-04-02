import 'package:app_3k_padel/features/auth/screens/reset_password_screen.dart';
import 'package:app_3k_padel/features/perfil/screens/complete_profile_screen.dart';
import 'package:app_3k_padel/services/user_service.dart';
import 'package:app_3k_padel/features/perfil/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_3k_padel/features/auth/screens/login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool isExchanging = true;

  @override
  void initState() {
    super.initState();
    _handleAuthRedirect();
  }

  Future<void> _handleAuthRedirect() async {
    try {
      final uri = Uri.base;

      // Detectar code en la URL
      final code = uri.queryParameters['code'];

      if (code != null) {
        await Supabase.instance.client.auth.exchangeCodeForSession(code);
      }
    } catch (e) {
      // El exchange puede fallar si el enlace de recuperación ha caducado,
      // ya fue utilizado o hay un problema de red.
      // En ese caso, no lanzamos excepción para evitar romper la UI.
      // El flujo continuará y, al no existir sesión válida, se mostrará el login.
    } finally {
      if (mounted) {
        setState(() {
          isExchanging = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mientras intercambia el code → loading
    if (isExchanging) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Mientras está cargando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data?.session;
        final event = snapshot.data?.event;

        // Recovery desde email
        if (event == AuthChangeEvent.passwordRecovery) {
          return const ResetPasswordScreen();
        }

        // También cubrir caso directo por URL con code
        final uri = Uri.base;
        if (uri.queryParameters['code'] != null) {
          return const ResetPasswordScreen();
        }

        // Si NO hay sesión → Login
        if (session == null) {
          return const LoginScreen();
        }

        return FutureBuilder(
          future: UserService().getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: SizedBox());
            }

            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            final usuario = snapshot.data;

            if (usuario == null) {
              return const LoginScreen();
            }

            if (!usuario.perfilCompleto) {
              return const CompleteProfileScreen();
            }

            return const PerfilScreen();
          },
        );
      },
    );
  }
}