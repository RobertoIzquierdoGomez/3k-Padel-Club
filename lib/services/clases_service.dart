import 'package:app_3k_padel/core/supabase_config.dart';
import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/model/clases_model.dart';

class ClasesService {
  final _db = SupabaseConfig.client;

  Future<List<ClasesModel>> getAllClases() async {
    try {
      AppLogger.info("Obteniendo lista de clases", tag: "CLASES_SERVICE");
      final data = await _db
          .from('clases')
          .select('''
          *,
          asignacion_clase(
            usuario:usuarios(
              id_usuario,
              nombre,
              apellidos
            )
          )
        ''')
          .order('dia_semana', ascending: true)
          .order('hora_inicio', ascending: true);

      AppLogger.info("Clases obtenidas: ${data.length}", tag: "CLASES_SERVICE");
      return data.map((e) => ClasesModel.fromJson(e)).toList();
    } catch (e) {
      AppLogger.error("Error obteniendo clases: $e", tag: "CLASES_SERVICE");
      rethrow;
    }
  }
}
