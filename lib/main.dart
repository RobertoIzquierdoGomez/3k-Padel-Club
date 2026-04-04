import 'package:app_3k_padel/features/auth/screens/reset_password_screen.dart';
import 'package:app_3k_padel/features/auth/widget/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:app_3k_padel/core/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseConfig.init();

  runApp(const MyApp());
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;
bool isRecoveringPassword = false;

class MyApp extends StatelessWidget {
  
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final uri = Uri.base;

    Widget home;

    // 🔥 DETECTAR RESET PASSWORD
    if (uri.path == '/reset-password') {
      home = const ResetPasswordScreen();
    } else {
      home = const AuthGate();
    }

    return MaterialApp(
      title: '3K Padel',
      home: home,
      debugShowCheckedModeBanner: false,
    );
  }
}