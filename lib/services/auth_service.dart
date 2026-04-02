import 'package:app_3k_padel/main.dart';
import 'package:app_3k_padel/model/user_model.dart';
import 'package:app_3k_padel/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

  Future<void> login(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      UserModel? user = await UserService().getCurrentUser();

      if (user == null) {
        await supabase.auth.signOut();
        throw AuthException("Usuario desactivado");
      }

    } on AuthException {
      rethrow;
    } catch (e) {
      throw Exception("Error inesperado");
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      return res.user;

    } on AuthException {
      rethrow;
    } catch (e) {
      throw Exception("Error inesperado");
    }
  }

  Future<void> updatePassword(String password) async {
    try {
      await supabase.auth.updateUser(
        UserAttributes(password: password),
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw Exception("Error inesperado");
    }
  }
}