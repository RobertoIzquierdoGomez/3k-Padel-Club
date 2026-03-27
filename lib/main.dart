import 'package:app_3k_padel/features/auth/screens/login_screen.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3K Padel',
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
