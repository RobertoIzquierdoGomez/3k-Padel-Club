
class UserModel {
  final String idUsuario;
  final String nombre;
  final String apellidos;
  final String correo;
  final double nivel;
  final bool tipoMiembro;
  final String rol;
  final bool perfilCompleto;
  final bool activo;

  UserModel({required this.idUsuario, required this.nombre, required this.apellidos, required this.correo,required this.nivel, required this.tipoMiembro, required this.rol, required this.perfilCompleto, required this.activo});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUsuario: (json['id_usuario'] as String?) ?? "",
      nombre: (json['nombre'] as String?) ?? "",
      apellidos: (json['apellidos'] as String?) ?? "",
      correo: (json['correo'] as String?) ?? "",
      nivel: (json['nivel'] as num?)?.toDouble() ?? 0.0,
      tipoMiembro: json['tipo_miembro'],
      rol: json['rol'],
      perfilCompleto: json['perfil_completo'],
      activo: json['activo']
    ); 
  }

  Map<String, dynamic> toJson(){
    return {
      'id_usuario': idUsuario,
      'nombre': nombre,
      'apellidos': apellidos,
      'correo': correo,
      'nivel': nivel,
      'tipo_miembro': tipoMiembro,
      'rol': rol,
      'cambiar_password': perfilCompleto,
      'activo': activo
    };
  }
}

