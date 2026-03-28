
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

  Future<String?> login(String email, String password) async {
    try{
      final AuthResponse res = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password
      );

      //final Session? session = res.session;
      //final User? user = res.user;
      return null;
    } on AuthException {
      return "Email o contraseña incorrectos";
    }catch (e){
      return "Se ha producido un error inesperado";
    }
  }
}