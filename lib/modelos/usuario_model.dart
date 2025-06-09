class UsuarioModel {
  final int id;
  final String nombre;
  final String? email;
  final int nivel;
  final int edad;
  final String? authUser;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UsuarioModel({
    required this.id,
    required this.nombre,
    this.email,
    required this.nivel,
    required this.edad,
    this.authUser,
    this.createdAt,
    this.updatedAt,
  });

  /// Crea un UsuarioModel desde un Map (respuesta de Supabase)
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    print('📝 [UsuarioModel] Creando usuario desde JSON: $json');

    return UsuarioModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      email: json['email'] as String?,
      nivel: json['nivel'] as int,
      edad: json['edad'] as int,
      authUser: json['auth_user'] as String?,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
    );
  }

  /// Convierte el UsuarioModel a Map para enviar a Supabase
  Map<String, dynamic> toJson() {
    final json = {
      'nombre': nombre,
      'email': email,
      'nivel': nivel,
      'edad': edad,
      'auth_user': authUser,
    };

    print('📤 [UsuarioModel] Convirtiendo usuario a JSON: $json');
    return json;
  }

  /// Convierte a Map incluyendo el ID (para updates)
  Map<String, dynamic> toJsonWithId() {
    final json = toJson();
    json['id'] = id;
    return json;
  }

  /// Crea una copia del usuario con campos modificados
  UsuarioModel copyWith({
    int? id,
    String? nombre,
    String? email,
    int? nivel,
    int? edad,
    String? authUser,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      nivel: nivel ?? this.nivel,
      edad: edad ?? this.edad,
      authUser: authUser ?? this.authUser,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UsuarioModel(id: $id, nombre: $nombre, nivel: $nivel, edad: $edad)';
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
