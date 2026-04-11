import 'package:app_3k_padel/model/user_model.dart';
import 'package:intl/intl.dart';

class ClasesModel {
  final String idClase;
  final int diaSemana;
  final String horaInicio;
  final String horaFin;
  final bool estadoClase;
  final List<UserModel> usuarios;

  static const Map<int, String> diasSemana = {
    1: 'Lunes',
    2: 'Martes',
    3: 'Miércoles',
    4: 'Jueves',
    5: 'Viernes',
    6: 'Sábado',
    7: 'Domingo',
  };

  ClasesModel({
    required this.idClase,
    required this.diaSemana,
    required this.horaInicio,
    required this.horaFin,
    required this.estadoClase,
    required this.usuarios,
  });

  static String _parseHora(dynamic hora) {
    if (hora == null) return "";

    final str = hora.toString().trim();

    final partes = str.split(':');
    if (partes.length >= 2) {
      return '${partes[0].padLeft(2, '0')}:${partes[1].padLeft(2, '0')}';
    }

    return str;
  }

  factory ClasesModel.fromJson(Map<String, dynamic> json) {
    return ClasesModel(
      idClase: (json['id_clase'] as String?) ?? "",
      diaSemana: json['dia_semana'] ?? 0,
      horaInicio: _parseHora(json['hora_inicio']),
      horaFin: _parseHora(json['hora_fin']),
      estadoClase: json['estado_clase'] ?? true,
      usuarios: (json['asignacion_clase'] as List<dynamic>? ?? [])
          .map((e) => UserModel.fromJson(e['usuario']))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_clase': idClase,
      'dia_semana': diaSemana,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
      'estado_clase': estadoClase,
    };
  }

  String _formatearHora(String hora) {
    if (hora.isEmpty) return "";

    final partes = hora.split(':');
    if (partes.length < 2) return hora;

    final dateTime = DateTime(
      0,
      1,
      1,
      int.tryParse(partes[0]) ?? 0,
      int.tryParse(partes[1]) ?? 0,
    );

    return DateFormat('HH:mm').format(dateTime);
  }

  String get horaInicioFormateada => _formatearHora(horaInicio);
  String get horaFinFormateada => _formatearHora(horaFin);

  String get diaSemanaNombre => diasSemana[diaSemana] ?? '';
}