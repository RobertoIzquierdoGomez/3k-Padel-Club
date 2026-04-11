import 'package:app_3k_padel/core/supabase_config.dart';
import 'package:app_3k_padel/core/utils/app_logger.dart';

class ParticipacionReservaService {
  final _db = SupabaseConfig.client;

  Future<void> deleteParticipacion(String idReserva, String idUsuario) async {
    try {
      AppLogger.info(
        "Eliminando participación de reserva $idReserva del usuario $idUsuario",
        tag: "PARTICIPACION_RESERVA_SERVICE",
      );
      final response = await _db
          .from('participacion_reserva')
          .delete()
          .eq('id_reserva', idReserva)
          .eq('id_usuario', idUsuario)
          .select();

      if (response.isEmpty) {
        AppLogger.warning(
          "No se encontró participación para eliminar (reserva: $idReserva, usuario: $idUsuario)",
          tag: "PARTICIPACION_RESERVA_SERVICE",
        );
      } else {
        AppLogger.info(
          "Participación eliminada correctamente (reserva: $idReserva, usuario: $idUsuario)",
          tag: "PARTICIPACION_RESERVA_SERVICE",
        );
      }
    } catch (e) {
      AppLogger.error(
        "Error eliminando participación $idReserva del usuario $idUsuario: $e",
        tag: "PARTICIPACION_RESERVA_SERVICE",
      );
      rethrow;
    }
  }
}
