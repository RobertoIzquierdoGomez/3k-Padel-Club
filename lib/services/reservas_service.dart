import 'package:app_3k_padel/core/supabase_config.dart';
import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/model/reservas_model.dart';

class ReservasService {
  final _db = SupabaseConfig.client;

  Future<List<ReservasModel>> getAllReservas() async {
    try {
      AppLogger.info("Obteniendo lista de reservas", tag: "RESERVA_SERVICE");
      final data = await _db
          .from('reservas')
          .select('''
        *,
        pistas(
          nombre
        ),
        participacion_reserva (
          usuario:usuarios(
            id_usuario,
            nombre,
            apellidos,
            correo,
            nivel,
            tipo_miembro,
            rol,
            perfil_completo,
            activo
          )  
        )
      ''')
          .order('fecha', ascending: true)
          .order('hora_inicio', ascending: true);

      AppLogger.info(
        "Reservas obtenidas: ${data.length}",
        tag: "RESERVA_SERVICE",
      );

      return data.map((e) => ReservasModel.fromJson(e)).toList();
    } catch (e) {
      AppLogger.error("Error obteniendo reservas: $e", tag: "RESERVA_SERVICE");
      rethrow;
    }
  }

  Future<void> deleteReserva(String id) async {
    try {
      AppLogger.info("Eliminando reserva $id", tag: "RESERVA_SERVICE");
      await _db.from('reservas').delete().eq('id_reserva', id);
      AppLogger.info(
        "Reserva $id eliminada correctamente",
        tag: "RESERVA_SERVICE",
      );
    } catch (e) {
      AppLogger.error(
        "Error eliminando reserva $id: $e",
        tag: "RESERVA_SERVICE",
      );
      rethrow;
    }
  }

  Future<void> insertReserva(
    String idPista,
    DateTime fecha,
    String horaInicio,
    String horaFin, {
    int? capacidadMaxima,
  }) async {
    try {
      AppLogger.info(
        "Insertando reserva con $idPista para el día $fecha de $horaInicio a $horaFin",
        tag: "RESERVA_SERVICE",
      );
      await _db.from('reservas').insert({
        'id_pista': idPista,
        'fecha': fecha.toIso8601String(),
        'hora_inicio': horaInicio,
        'hora_fin': horaFin,
        if (capacidadMaxima != null) 'capacidad_maxima': capacidadMaxima,
      });
    } catch (e) {
      AppLogger.error(
        "Error insertando reserva con pista $idPista para el día $fecha de $horaInicio a $horaFin: $e",
        tag: "RESERVA_SERVICE",
      );
      rethrow;
    }
  }

  Future<void> updateReserva(
    String id,
    String idPista,
    DateTime fecha,
    String horaInicio,
    String horaFin, {
    int? capacidadMaxima,
  }) async {
    try {
      AppLogger.info("Actualizando reserva $id", tag: "RESERVA_SERVICE");

      await _db
          .from('reservas')
          .update({
            "id_pista": idPista,
            'fecha': fecha.toIso8601String(),
            'hora_inicio': horaInicio,
            'hora_fin': horaFin,
            if (capacidadMaxima != null) 'capacidad_maxima': capacidadMaxima,
          })
          .eq('id_reserva', id);

      AppLogger.info(
        "Reserva actualizada correctamente para reserva $id",
        tag: "RESERVA_SERVICE",
      );
    } catch (e) {
      AppLogger.error("Error actualizando reserva $id", tag: "RESERVA_SERVICE");
      rethrow;
    }
  }
}
