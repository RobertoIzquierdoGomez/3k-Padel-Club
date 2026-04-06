import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/features/auth/widget/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:app_3k_padel/core/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info("Inicializando aplicación", tag: "APP");

  await SupabaseConfig.init();

  AppLogger.info("Supabase inicializado correctamente", tag: "APP");

  runApp(const MyApp());
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;
bool isRecoveringPassword = false;

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: '3K Padel',
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}