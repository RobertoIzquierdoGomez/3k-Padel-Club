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
          .order('dia_semana', ascending: true)
          .order('hora_inicio', ascending: true);

      AppLogger.info("Clases obtenidas: ${data.length}", tag: "CLASES_SERVICE");
      return data.map((e) => ClasesModel.fromJson(e)).toList();
    } catch (e) {
      AppLogger.error("Error obteniendo clases: $e", tag: "CLASES_SERVICE");
      rethrow;
    }
  }

  Future<void> insertClase(int diaSemana, String horaInicio, String horaFin) async {
    try {
      AppLogger.info(
        "Insertando clase para día $diaSemana de $horaInicio a $horaFin",
        tag: "CLASE_SERVICE",
      );
      await _db.from('clases').insert({
        'dia_semana': diaSemana,
        'hora_inicio': horaInicio,
        'hora_fin': horaFin,
      });
    } catch (e) {
      AppLogger.error(
        "Error insertando clase para día $diaSemana de $horaInicio a $horaFin: $e",
        tag: "CLASE_SERVICE",
      );
      rethrow;
    }
  }

  Future<void> updateClase(
    String idClase,
    int diaSemana,
    String horaInicio,
    String horaFin,
    bool estadoClase
  ) async {
    try {
      AppLogger.info("Actualizando clase $idClase", tag: "CLASES_SERVICE");

      await _db
          .from('clases')
          .update({
            'dia_semana': diaSemana,
            'hora_inicio': horaInicio,
            'hora_fin': horaFin,
            'estado_clase': estadoClase,
          })
          .eq('id_clase', idClase);

      AppLogger.info(
        "Clase actualizada correctamente para $idClase",
        tag: "CLASES_SERVICE",
      );
    } catch (e) {
      AppLogger.error("Error actualizando clase $idClase: $e", tag: "CLASES_SERVICE");
      rethrow;
    }
  }
}
