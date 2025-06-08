class InvitadoModel {
  final int id;
  final String nombre;
  final int edad;
  final int nivel;
  final DateTime? createdAt;
  
  InvitadoModel({
    required this.id,
    required this.nombre,
    required this.edad,
    required this.nivel,
    this.createdAt,
  });
  
  /// Crea un InvitadoModel desde un Map (respuesta de Supabase)
  factory InvitadoModel.fromJson(Map<String, dynamic> json) {
    print('📝 [InvitadoModel] Creando invitado desde JSON: $json');
    
    return InvitadoModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      edad: json['edad'] as int,
      nivel: json['nivel'] as int,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
  
  /// Convierte el InvitadoModel a Map para enviar a Supabase
  Map<String, dynamic> toJson() {
    final json = {
      'nombre': nombre,
      'edad': edad,
      'nivel': nivel,
    };
    
    print('📤 [InvitadoModel] Convirtiendo invitado a JSON: $json');
    return json;
  }
  
  /// Convierte a Map incluyendo el ID (para updates)
  Map<String, dynamic> toJsonWithId() {
    final json = toJson();
    json['id'] = id;
    return json;
  }
  
  /// Crea una copia del invitado con campos modificados
  InvitadoModel copyWith({
    int? id,
    String? nombre,
    int? edad,
    int? nivel,
    DateTime? createdAt,
  }) {
    return InvitadoModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      edad: edad ?? this.edad,
      nivel: nivel ?? this.nivel,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  @override
  String toString() {
    return 'InvitadoModel(id: $id, nombre: $nombre, edad: $edad, nivel: $nivel)';
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvitadoModel && runtimeType == other.runtimeType && id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}
