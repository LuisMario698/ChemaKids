class JuegoModel {
  final int id;
  final String nombre;
  final String descripcion;
  final DateTime? createdAt;
  
  JuegoModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    this.createdAt,
  });
  
  /// Crea un JuegoModel desde un Map (respuesta de Supabase)
  factory JuegoModel.fromJson(Map<String, dynamic> json) {
    print('📝 [JuegoModel] Creando juego desde JSON: $json');
    
    return JuegoModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
  
  /// Convierte el JuegoModel a Map para enviar a Supabase
  Map<String, dynamic> toJson() {
    final json = {
      'nombre': nombre,
      'descripcion': descripcion,
    };
    
    print('📤 [JuegoModel] Convirtiendo juego a JSON: $json');
    return json;
  }
  
  /// Convierte a Map incluyendo el ID (para updates)
  Map<String, dynamic> toJsonWithId() {
    final json = toJson();
    json['id'] = id;
    return json;
  }
  
  /// Crea una copia del juego con campos modificados
  JuegoModel copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    DateTime? createdAt,
  }) {
    return JuegoModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  @override
  String toString() {
    return 'JuegoModel(id: $id, nombre: $nombre, descripcion: $descripcion)';
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JuegoModel && runtimeType == other.runtimeType && id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}
