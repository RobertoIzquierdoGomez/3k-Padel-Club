import 'package:app_3k_padel/core/supabase_config.dart';
import 'package:app_3k_padel/core/utils/app_logger.dart';
import 'package:app_3k_padel/model/pista_model.dart';

class PistaService {
  final _db = SupabaseConfig.client;

  //Obtener todas las pistas
  Future<List<PistaModel>> getAllPistas() async {
    try {
      AppLogger.info("Obteniendo lista de pistas", tag: "PISTA_SERVICE");
      final data = await _db
          .from('pistas')
          .select()
          .order('nombre', ascending: true);

      AppLogger.info("Pistas obtenidas: ${data.length}", tag: "PISTA_SERVICE");

      return data.map((e) => PistaModel.fromJson(e)).toList();
    } catch (e) {
      AppLogger.error("Error obteniendo pistas: $e", tag: "PISTA_SERVICE");
      rethrow;
    }
  }

  Future<List<PistaModel>> getAllPistasActivas() async {
    try {
      AppLogger.info("Obteniendo lista de pistas", tag: "PISTA_SERVICE");
      final data = await _db
          .from('pistas')
          .select()
          .eq('estado', true)
          .order('nombre', ascending: true);

      AppLogger.info("Pistas obtenidas: ${data.length}", tag: "PISTA_SERVICE");

      return data.map((e) => PistaModel.fromJson(e)).toList();
    } catch (e) {
      AppLogger.error("Error obteniendo pistas: $e", tag: "PISTA_SERVICE");
      rethrow;
    }
  }

  //Eliminar pista
  Future<void> deletePista(String id) async {
    try {
      AppLogger.info("Eliminando pista $id", tag: "PISTA_SERVICE");
      await _db.from('pistas').delete().eq('id_pista', id);
      AppLogger.info("Pista $id eliminada correctamente", tag: "PISTA_SERVICE");
    } catch (e) {
      AppLogger.error("Error eliminando pista $id: $e", tag: "PISTA_SERVICE");
      rethrow;
    }
  }

  //Actualizar información de la pista por el administrador
  Future<void> updatePista(String id, String nombre, bool estado) async {
    try {
      AppLogger.info("Admin actualizando pista $id", tag: "PISTA_SERVICE");

      await _db
          .from('pistas')
          .update({"nombre": nombre, "estado": estado})
          .eq('id_pista', id);

      AppLogger.info(
        "Pista $id actualizada correctamente por admin",
        tag: "PISTA_SERVICE",
      );
    } catch (e) {
      AppLogger.error(
        "Error actualizando pista $id por admin: $e",
        tag: "PISTA_SERVICE",
      );
      rethrow;
    }
  }

  //Insertar pista
  Future<void> insertPista(String nombre, bool estado) async {
    try {
      AppLogger.info("Insertando pista $nombre", tag: "PISTA_SERVICE");

      await _db.from('pistas').insert({'nombre': nombre, 'estado': estado});

      AppLogger.info(
        "Pista $nombre insertada correctamente",
        tag: "PISTA_SERVICE",
      );
    } catch (e) {
      AppLogger.error(
        "Error insertando pista $nombre: $e",
        tag: "PISTA_SERVICE",
      );
      rethrow;
    }
  }
}
