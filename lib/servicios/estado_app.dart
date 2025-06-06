import 'package:flutter/foundation.dart';
import '../modelos/usuario.dart';

class EstadoApp extends ChangeNotifier {
  Usuario _usuario;
  
  EstadoApp()
      : _usuario = Usuario(
          nombre: 'Felipe',
          nivelesDesbloqueados: [1],
        );

  Usuario get usuario => _usuario;

  void desbloquearNivel(int nivel) {
    _usuario.desbloquearNivel(nivel);
    notifyListeners();
  }

  void actualizarPuntuacion(String nivel, int puntos) {
    _usuario.actualizarPuntuacion(nivel, puntos);
    notifyListeners();
  }
}
