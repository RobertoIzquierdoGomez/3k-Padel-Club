import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/core/supabase_config.dart';
import 'package:app_3k_padel/model/user_model.dart';

class UserService {
  final _db = SupabaseConfig.client;

  //Obtiene información de usuario autenticado
  Future<UserModel?> getCurrentUser() async {
    try {
      AppLogger.info("Obteniendo usuario actual", tag: "USER_SERVICE");

      final userAuthenticated = _db.auth.currentUser;

      if (userAuthenticated == null) {
        AppLogger.warning("No hay usuario autenticado", tag: "USER_SERVICE");
        return null;
      }

      final data = await _db
          .from('usuarios')
          .select()
          .eq('id_usuario', userAuthenticated.id);

      if (data.isEmpty) {
        AppLogger.warning(
          "Usuario autenticado sin datos en tabla usuarios",
          tag: "USER_SERVICE",
        );
        return null;
      } else {
        AppLogger.info("Usuario actual obtenido correctamente", tag: "USER_SERVICE");
        return UserModel.fromJson(data[0]);
      }
    } catch (e) {
      AppLogger.error("Error obteniendo usuario actual: $e", tag: "USER_SERVICE");
      rethrow;
    }
  }

  //Obtener todos los usuarios
  Future<List<UserModel>> getAllUsers() async {
    try {
      AppLogger.info("Obteniendo lista de usuarios activos", tag: "USER_SERVICE");

      final data = await _db
          .from('usuarios')
          .select()
          .eq('activo', true)
          .order('apellidos', ascending: true);

      AppLogger.info("Usuarios obtenidos: ${data.length}", tag: "USER_SERVICE");

      return data.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      AppLogger.error("Error obteniendo usuarios: $e", tag: "USER_SERVICE");
      rethrow;
    }
  }

  Future<List<UserModel>> getAllUsersClases() async {
    try {
      AppLogger.info("Obteniendo lista de usuarios activos para las clases", tag: "USER_SERVICE");

      final data = await _db
          .from('usuarios')
          .select()
          .eq('activo', true)
          .eq('perfil_completo', true)
          .order('apellidos', ascending: true);

      AppLogger.info("Usuarios obtenidos: ${data.length}", tag: "USER_SERVICE");

      return data.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      AppLogger.error("Error obteniendo usuarios para las clases: $e", tag: "USER_SERVICE");
      rethrow;
    }
  }

  //Actualizar usuario en el registro (propio usuario)
  Future<void> updateProfile(
    String id,
    String nombre,
    String apellidos,
    double nivel,
  ) async {
    try {
      AppLogger.info("Actualizando perfil de usuario $id", tag: "USER_SERVICE");

      await _db
          .from('usuarios')
          .update({
            "nombre": nombre,
            "apellidos": apellidos,
            "nivel": nivel,
            "perfil_completo": true,
          })
          .eq('id_usuario', id);

      AppLogger.info("Perfil actualizado correctamente para usuario $id", tag: "USER_SERVICE");
    } catch (e) {
      AppLogger.error("Error actualizando perfil de usuario $id: $e", tag: "USER_SERVICE");
      rethrow;
    }
  }

  //Actualizar información del usuario por el administrador
  Future<void> updateUserByAdmin(
    String id,
    String nombre,
    String apellidos,
    double nivel,
    bool tipoMiembro
  ) async {
    try {
      AppLogger.info("Admin actualizando usuario $id", tag: "USER_SERVICE");

      await _db
          .from('usuarios')
          .update({
            "nombre": nombre,
            "apellidos": apellidos,
            "nivel": nivel,
            "tipo_miembro": tipoMiembro
          })
          .eq('id_usuario', id);

      AppLogger.info("Usuario $id actualizado correctamente por admin", tag: "USER_SERVICE");
    } catch (e) {
      AppLogger.error("Error actualizando usuario $id por admin: $e", tag: "USER_SERVICE");
      rethrow;
    }
  }

  //Desactivar usuario por el administrador
  Future<void> disableUser(String id) async {
    try {
      AppLogger.info("Desactivando usuario $id", tag: "USER_SERVICE");

      await _db
          .from('usuarios')
          .update({'activo': false})
          .eq('id_usuario', id);

      AppLogger.info("Usuario $id desactivado correctamente", tag: "USER_SERVICE");
    } catch (e) {
      AppLogger.error("Error desactivando usuario $id: $e", tag: "USER_SERVICE");
      rethrow;
    }
  }
}