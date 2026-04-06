
class PistaModel {
  final String idPista;
  final String nombre;
  final bool estado;

  PistaModel({required this.idPista, required this.nombre, required this.estado});

  factory PistaModel.fromJson(Map<String, dynamic> json) {
    return PistaModel(
      idPista: (json['id_pista'] as String?) ?? "",
      nombre: (json['nombre'] as String?) ?? "",
      estado: json['estado'],
    ); 
  }

  Map<String, dynamic> toJson(){
    return {
      'id_pista': idPista,
      'nombre': nombre,
      'estado': estado
    };
  }
}