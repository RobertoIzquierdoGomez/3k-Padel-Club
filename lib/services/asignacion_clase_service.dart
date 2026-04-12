
import 'package:app_3k_padel/core/supabase_config.dart';
import 'package:app_3k_padel/core/utils/app_logger.dart';

class AsignacionClaseService {
  final _db = SupabaseConfig.client;

  Future<void> deleteAsignacion(String idClase, String idUsuario) async{
    try {
      AppLogger.info(
        "Eliminando asignación de clase $idClase del usuario $idUsuario",
        tag: "ASIGNACION_CLASE_SERVICE",
      );
      final response = await _db
          .from('asignacion_clase')
          .delete()
          .eq('id_clase', idClase)
          .eq('id_usuario', idUsuario)
          .select();

      if (response.isEmpty) {
        AppLogger.warning(
          "No se encontró asignación de clase $idClase del usuario $idUsuario",
          tag: "ASIGNACION_CLASE_SERVICE",
        );
      } else {
        AppLogger.info(
          "Asignación de clase eliminada correctamente (reserva: $idClase, usuario: $idUsuario)",
          tag: "ASIGNACION_CLASE_SERVICE",
        );
      }
    } catch (e) {
      AppLogger.error(
        "Error eliminando asignación de clase $idClase del usuario $idUsuario: $e",
        tag: "ASIGNACION_CLASE_SERVICE",
      );
      rethrow;
    }
  }

  Future<void> insertAsignacion(String idClase, String idUsuario) async{
    try {
      AppLogger.info(
        "Insertando asignación de clase $idClase a usuario $idUsuario",
        tag: "ASIGNACION_CLASE_SERVICE",
      );
      await _db.from('asignacion_clase').insert({
        'id_clase': idClase,
        'id_usuario': idUsuario
      });
    } catch (e) {
      AppLogger.error(
        "Error insertando asignación de clase $idClase a usuario $idUsuario: $e",
        tag: "ASIGNACION_CLASE_SERVICE",
      );
      rethrow;
    }
  }
}