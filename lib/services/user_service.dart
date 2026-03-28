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


}