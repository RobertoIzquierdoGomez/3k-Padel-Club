
class UserModel {
  final String idUsuario;
  final String nombre;
  final String apellidos;
  final String correo;
  final double nivel;
  final bool tipoMiembro;
  final String rol;
  final bool cambiarPassword;

  UserModel({required this.idUsuario, required this.nombre, required this.apellidos, required this.correo,required this.nivel, required this.tipoMiembro, required this.rol, required this.cambiarPassword});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUsuario: json['id_usuario'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      correo: json['correo'],
      nivel: (json['nivel'] as num?)?.toDouble() ?? 0.0,
      tipoMiembro: json['tipo_miembro'],
      rol: json['rol'],
      cambiarPassword: json['cambiar_password'],
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
      'cambiar_password': cambiarPassword,
    };
  }
}

