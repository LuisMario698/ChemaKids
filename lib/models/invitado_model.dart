class InvitadoModel {
  final int id;
  final String nombre;
  final int edad;
  final int idProgreso;

  InvitadoModel({
    required this.id,
    required this.nombre,
    required this.edad,
    required this.idProgreso,
  });

  /// Crea un InvitadoModel desde un Map (respuesta de Supabase)
  factory InvitadoModel.fromJson(Map<String, dynamic> json) {
    print('📝 [InvitadoModel] Creando invitado desde JSON: $json');

    return InvitadoModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      edad: json['edad'] as int,
      idProgreso: json['id_progreso'] as int,
    );
  }

  /// Convierte el InvitadoModel a Map para enviar a Supabase
  Map<String, dynamic> toJson() {
    final json = {
      'nombre': nombre,
      'edad': edad,
      // id_progreso se asigna en el servicio
    };

    print('📤 [InvitadoModel] Convirtiendo invitado a JSON: $json');
    return json;
  }

  /// Convierte a Map incluyendo el ID (para updates)
  Map<String, dynamic> toJsonWithId() {
    final json = toJson();
    json['id'] = id;
    json['id_progreso'] = idProgreso;
    return json;
  }

  /// Crea una copia del invitado con campos modificados
  InvitadoModel copyWith({
    int? id,
    String? nombre,
    int? edad,
    int? idProgreso,
  }) {
    return InvitadoModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      edad: edad ?? this.edad,
      idProgreso: idProgreso ?? this.idProgreso,
    );
  }

  @override
  String toString() {
    return 'InvitadoModel(id: $id, nombre: $nombre, edad: $edad, idProgreso: $idProgreso)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvitadoModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
