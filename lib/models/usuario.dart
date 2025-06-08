class Usuario {
  final String nombre;
  final List<int> nivelesDesbloqueados;
  final Map<String, int> puntuacionPorNivel;

  Usuario({
    required this.nombre,
    List<int>? nivelesDesbloqueados,
    Map<String, int>? puntuacionPorNivel,
  })  : nivelesDesbloqueados = nivelesDesbloqueados ?? [1],
        puntuacionPorNivel = puntuacionPorNivel ?? {};

  bool nivelDesbloqueado(int nivel) {
    return nivelesDesbloqueados.contains(nivel);
  }

  void desbloquearNivel(int nivel) {
    if (!nivelesDesbloqueados.contains(nivel)) {
      nivelesDesbloqueados.add(nivel);
    }
  }

  void actualizarPuntuacion(String nivel, int puntos) {
    final puntuacionActual = puntuacionPorNivel[nivel] ?? 0;
    if (puntos > puntuacionActual) {
      puntuacionPorNivel[nivel] = puntos;
    }
  }
}