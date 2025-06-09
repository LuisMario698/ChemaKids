class ProgresoModel {
  final int id;
  final int idJuego;
  final int nivel;
  final int puntaje;
  final int rachaMaxima;
  final int idUsuario;
  final int idInvitado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProgresoModel({
    required this.id,
    required this.idJuego,
    required this.nivel,
    required this.puntaje,
    required this.rachaMaxima,
    required this.idUsuario,
    required this.idInvitado,
    this.createdAt,
    this.updatedAt,
  });

  /// Crea un ProgresoModel desde un Map (respuesta de Supabase)
  factory ProgresoModel.fromJson(Map<String, dynamic> json) {
    print('📝 [ProgresoModel] Creando progreso desde JSON: $json');

    return ProgresoModel(
      id: json['id'] as int,
      idJuego: json['id_juego'] as int,
      nivel: json['nivel'] as int,
      puntaje: json['puntaje'] as int,
      rachaMaxima: json['racha_maxima'] as int,
      idUsuario: json['id_usuario'] as int,
      idInvitado: json['id_invitado'] as int,
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

  /// Convierte el ProgresoModel a Map para enviar a Supabase
  Map<String, dynamic> toJson() {
    final json = {
      'id_juego': idJuego,
      'nivel': nivel,
      'puntaje': puntaje,
      'racha_maxima': rachaMaxima,
      'id_usuario': idUsuario,
      'id_invitado': idInvitado,
    };

    print('📤 [ProgresoModel] Convirtiendo progreso a JSON: $json');
    return json;
  }

  /// Convierte a Map incluyendo el ID (para updates)
  Map<String, dynamic> toJsonWithId() {
    final json = toJson();
    json['id'] = id;
    return json;
  }

  /// Crea una copia del progreso con campos modificados
  ProgresoModel copyWith({
    int? id,
    int? idJuego,
    int? nivel,
    int? puntaje,
    int? rachaMaxima,
    int? idUsuario,
    int? idInvitado,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProgresoModel(
      id: id ?? this.id,
      idJuego: idJuego ?? this.idJuego,
      nivel: nivel ?? this.nivel,
      puntaje: puntaje ?? this.puntaje,
      rachaMaxima: rachaMaxima ?? this.rachaMaxima,
      idUsuario: idUsuario ?? this.idUsuario,
      idInvitado: idInvitado ?? this.idInvitado,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ProgresoModel(id: $id, juego: $idJuego, nivel: $nivel, puntaje: $puntaje, racha: $rachaMaxima)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgresoModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
