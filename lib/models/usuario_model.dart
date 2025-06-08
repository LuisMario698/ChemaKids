class UsuarioModel {
  final int id;
  final String nombre;
  final String? email;
  final int edad;
  final String? authUser;
  final int idProgreso;

  UsuarioModel({
    required this.id,
    required this.nombre,
    this.email,
    required this.edad,
    this.authUser,
    required this.idProgreso,
  });

  /// Crea un UsuarioModel desde un Map (respuesta de Supabase)
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    print('📝 [UsuarioModel] Creando usuario desde JSON: $json');

    return UsuarioModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      email: json['email'] as String?,
      edad: json['edad'] as int,
      authUser: json['auth_user'] as String?,
      idProgreso: json['id_progreso'] as int,
    );
  }

  /// Convierte el UsuarioModel a Map para enviar a Supabase
  Map<String, dynamic> toJson() {
    final json = {
      'nombre': nombre,
      'email': email,
      'edad': edad,
      'auth_user': authUser,
      // id_progreso se asigna en el servicio
    };

    print('📤 [UsuarioModel] Convirtiendo usuario a JSON: $json');
    return json;
  }

  /// Convierte a Map incluyendo el ID (para updates)
  Map<String, dynamic> toJsonWithId() {
    final json = toJson();
    json['id'] = id;
    json['id_progreso'] = idProgreso;
    return json;
  }

  /// Crea una copia del usuario con campos modificados
  UsuarioModel copyWith({
    int? id,
    String? nombre,
    String? email,
    int? edad,
    String? authUser,
    int? idProgreso,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      edad: edad ?? this.edad,
      authUser: authUser ?? this.authUser,
      idProgreso: idProgreso ?? this.idProgreso,
    );
  }

  @override
  String toString() {
    return 'UsuarioModel(id: $id, nombre: $nombre, edad: $edad, idProgreso: $idProgreso)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsuarioModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
