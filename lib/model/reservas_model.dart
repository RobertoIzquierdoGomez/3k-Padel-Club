import 'package:app_3k_padel/model/user_model.dart';
import 'package:intl/intl.dart';

class ReservasModel {
  final String idReserva;
  final String idPista;
  final String pista;
  final DateTime fecha;
  final String horaInicio;
  final String horaFin;
  final int capacidadMaxima;
  final bool estado;
  final List<UserModel> usuarios;

  ReservasModel({
    required this.idReserva,
    required this.idPista,
    required this.pista,
    required this.fecha,
    required this.horaFin,
    required this.horaInicio,
    required this.estado,
    required this.usuarios,
    required this.capacidadMaxima,
  });

  static String _parseHora(dynamic hora) {
    if (hora == null) return "";

    final str = hora.toString().trim();

    if (str.length >= 5) {
      return str.substring(0, 5);
    }

    return str;
  }

  factory ReservasModel.fromJson(Map<String, dynamic> json) {
    return ReservasModel(
      idReserva: (json['id_reserva'] as String?) ?? "",
      idPista: (json['id_pista'] as String?) ?? "",
      pista: json['pistas']?['nombre'] ?? "",
      fecha: DateTime.parse(json['fecha']),
      
      horaInicio: _parseHora(json['hora_inicio']),
      horaFin: _parseHora(json['hora_fin']),

      capacidadMaxima: json['capacidad_maxima'] ?? 0,
      estado: json['estado'] ?? false,
      usuarios: (json['participacion_reserva'] as List<dynamic>? ?? [])
          .map((e) => UserModel.fromJson(e['usuario']))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_reserva': idReserva,
      'id_pista': idPista,
      'fecha': fecha.toIso8601String(),

      'hora_inicio': horaInicio,
      'hora_fin': horaFin,

      'capacidad_maxima': capacidadMaxima,
      'estado': estado,
    };
  }

  double get nivelPromedio {
    if (usuarios.isEmpty) return 0.0;

    final suma = usuarios.fold(0.0, (acc, user) => acc + user.nivel);
    return (suma / usuarios.length);
  }

  String get nivelPromedioTexto {
    return nivelPromedio.toStringAsFixed(1);
  }

  String get fechaFormateada {
    return DateFormat('dd/MM/yyyy').format(fecha);
  }

  String get horaInicioFormateada {
    final partes = horaInicio.split(':');
    final dateTime = DateTime(
      0,
      1,
      1,
      int.parse(partes[0]),
      int.parse(partes[1]),
    );

    return DateFormat('HH:mm').format(dateTime);
  }

  String get horaFinFormateada {
    final partes = horaFin.split(':');
    final dateTime = DateTime(
      0,
      1,
      1,
      int.parse(partes[0]),
      int.parse(partes[1]),
    );

    return DateFormat('HH:mm').format(dateTime);
  }
}