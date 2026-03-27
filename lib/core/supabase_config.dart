import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Inicializa Supabase
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://jtdspsdgeiaipgecxkbz.supabase.co',
      anonKey: 'sb_publishable_Dk6GvOblPwvzxCk-dcVj5Q_uLRdG-uo',
    );
  }

  // Atajo para acceder al cliente
  static SupabaseClient get client => Supabase.instance.client;
}
