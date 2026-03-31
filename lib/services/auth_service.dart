
import 'package:app_3k_padel/main.dart';
import 'package:app_3k_padel/model/user_model.dart';
import 'package:app_3k_padel/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

  Future<String?> login(String email, String password) async {
    try{
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password
      );

      UserModel? user = await UserService().getCurrentUser();
      
      if(user == null) {
        await supabase.auth.signOut();
        return "Usuario desactivado";
      }

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