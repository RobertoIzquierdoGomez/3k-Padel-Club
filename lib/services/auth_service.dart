import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/main.dart';
import 'package:app_3k_padel/model/user_model.dart';
import 'package:app_3k_padel/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  Future<void> login(String email, String password) async {
    try {
      AppLogger.info("Intentando login", tag: "AUTH_SERVICE");

      await supabase.auth.signInWithPassword(email: email, password: password);

      AppLogger.info("Login correcto en Supabase", tag: "AUTH_SERVICE");

      UserModel? user = await UserService().getCurrentUser();

      if (user == null) {
        AppLogger.warning("Usuario sin datos tras login (posible desactivado)", tag: "AUTH_SERVICE");

        await supabase.auth.signOut();
        throw AuthException("Usuario desactivado");
      }

      AppLogger.info("Usuario validado correctamente tras login", tag: "AUTH_SERVICE");

    } on AuthException catch (e) {
      AppLogger.error("Error de autenticación en login: ${e.message}", tag: "AUTH_SERVICE");
      rethrow;
    } catch (e) {
      AppLogger.error("Error inesperado en login: $e", tag: "AUTH_SERVICE");
      throw Exception("Error inesperado");
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      AppLogger.info("Intentando registro de usuario", tag: "AUTH_SERVICE");

      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      AppLogger.info("Registro ejecutado correctamente", tag: "AUTH_SERVICE");

      return res.user;

    } on AuthException catch (e) {
      AppLogger.error("Error en registro: ${e.message}", tag: "AUTH_SERVICE");
      rethrow;
    } catch (e) {
      AppLogger.error("Error inesperado en registro: $e", tag: "AUTH_SERVICE");
      throw Exception("Error inesperado");
    }
  }

  Future<void> updatePassword(String password) async {
    try {
      AppLogger.info("Actualizando contraseña", tag: "AUTH_SERVICE");

      await supabase.auth.updateUser(UserAttributes(password: password));

      AppLogger.info("Contraseña actualizada correctamente", tag: "AUTH_SERVICE");

    } on AuthException catch (e) {
      AppLogger.error("Error actualizando contraseña: ${e.message}", tag: "AUTH_SERVICE");
      rethrow;
    } catch (e) {
      AppLogger.error("Error inesperado actualizando contraseña: $e", tag: "AUTH_SERVICE");
      throw Exception("Error inesperado");
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      AppLogger.info("Enviando email de recuperación de contraseña", tag: "AUTH_SERVICE");

      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'http://localhost:3000/reset-password',
      );

      AppLogger.info("Email de recuperación enviado correctamente", tag: "AUTH_SERVICE");

    } on AuthException catch (e) {
      AppLogger.error("Error enviando email de recuperación: ${e.message}", tag: "AUTH_SERVICE");
      rethrow;
    } catch (e) {
      AppLogger.error("Error inesperado enviando email de recuperación: $e", tag: "AUTH_SERVICE");
      throw Exception("Error inesperado");
    }
  }

  Future<void> sendOtpEmail(String email) async {
    try {
      AppLogger.info("Enviando OTP por email", tag: "AUTH_SERVICE");

      await supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: false,
        emailRedirectTo: null,
      );

      AppLogger.info("OTP enviado correctamente", tag: "AUTH_SERVICE");

    } on AuthException catch (e) {
      AppLogger.error("Error enviando OTP: ${e.message}", tag: "AUTH_SERVICE");
      rethrow;
    } catch (e) {
      AppLogger.error("Error inesperado enviando OTP: $e", tag: "AUTH_SERVICE");
      throw Exception("Error inesperado");
    }
  }
}