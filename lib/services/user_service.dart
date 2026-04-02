import 'package:app_3k_padel/core/supabase_config.dart';
import 'package:app_3k_padel/model/user_model.dart';

class UserService {

  final _db = SupabaseConfig.client;

  //Obtiene información de usuario autenticado
  Future <UserModel?> getCurrentUser() async {

    final userAuthenticated = _db.auth.currentUser;
    if (userAuthenticated == null) return null;
    
    final data = await _db
    .from('usuarios')
    .select()
    .eq('id_usuario', userAuthenticated.id);

    if(data.isEmpty){
      return null;
    } else {
      return UserModel.fromJson(data[0]);
    }
  }

  //Obtener todos los usuarios
  Future <List<UserModel?>?> getAllUsers() async {

    final data = await _db
    .from('usuarios')
    .select();

    if(data.isEmpty){
      return null;
    } else {
      print(data);
      return data.map(
        (e) => UserModel.fromJson(e)
      ).toList();
    }
  }

  //Actualizar usuario en el registro (propio usuario)
  Future <void> updateProfile(String id, String nombre, String apellidos, double nivel) async {
    await _db
      .from('usuarios')
      .update({
        "nombre": nombre,
        "apellidos": apellidos,
        "nivel": nivel,
        "perfil_completo": true
      })
      .eq('id_usuario', id);
  }

  //Actualizar información del usuario por el administrador
  Future <void> updateUserByAdmin(String id, String name, String apellidos, double nivel, bool tipoMiembro, bool perfilCompleto, bool activo) async {

  }

  //Desactivar usuario por el administrador
  Future <void> disableUser(String id, String name, String apellidos, double nivel, bool tipoMiembro, bool perfilCompleto, bool activo) async {

  }


}