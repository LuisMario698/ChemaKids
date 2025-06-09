import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

/// Servicio para manejar Text-to-Speech en la aplicación ChemaKids
///
/// Este servicio proporciona funcionalidades para:
/// - Reproducir texto en español con voz natural
/// - Controlar la velocidad y tono de voz
/// - Manejar estados de reproducción
/// - Configurar idioma específico para niños
class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  TTSService._internal();

  late FlutterTts _flutterTts;
  bool _isInitialized = false;
  bool _isPlaying = false;

  /// Inicializa el servicio TTS con configuración optimizada para niños
  Future<void> initialize() async {
    if (_isInitialized) return;

    _flutterTts = FlutterTts();

    try {
      // Configuración de idioma español
      await _flutterTts.setLanguage("es-ES");

      // Configuración de velocidad (más lenta para niños)
      await _flutterTts.setSpeechRate(0.4);

      // Configuración de volumen
      await _flutterTts.setVolume(1.0);

      // Configuración de tono (más agudo para ser más atractivo para niños)
      await _flutterTts.setPitch(1.2);

      // Configurar callbacks para manejar estados
      _flutterTts.setStartHandler(() {
        _isPlaying = true;
        if (kDebugMode) {
          print("🎵 TTS: Iniciando reproducción");
        }
      });

      _flutterTts.setCompletionHandler(() {
        _isPlaying = false;
        if (kDebugMode) {
          print("✅ TTS: Reproducción completada");
        }
      });

      _flutterTts.setErrorHandler((msg) {
        _isPlaying = false;
        if (kDebugMode) {
          print("❌ TTS Error: $msg");
        }
      });

      _isInitialized = true;
      if (kDebugMode) {
        print("🎉 TTSService inicializado correctamente");
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error inicializando TTSService: $e");
      }
    }
  }

  /// Reproduce un texto usando TTS
  ///
  /// [text] - El texto a reproducir
  /// [speedRate] - Velocidad de reproducción (opcional, por defecto 0.4)
  /// [pitch] - Tono de voz (opcional, por defecto 1.2)
  Future<void> speak(String text, {double? speedRate, double? pitch}) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Detener cualquier reproducción anterior
      await stop();

      // Configurar parámetros si se proporcionan
      if (speedRate != null) {
        await _flutterTts.setSpeechRate(speedRate);
      }

      if (pitch != null) {
        await _flutterTts.setPitch(pitch);
      }

      // Reproducir el texto
      await _flutterTts.speak(text);

      if (kDebugMode) {
        print("🗣️ TTS: Reproduciendo '$text'");
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error reproduciendo TTS: $e");
      }
    }
  }

  /// Reproduce un número específico (optimizado para números del 1 al 10)
  Future<void> speakNumber(int number) async {
    if (number < 1 || number > 10) {
      if (kDebugMode) {
        print("⚠️ Número fuera de rango: $number");
      }
      return;
    }

    final numberWords = {
      1: "uno",
      2: "dos",
      3: "tres",
      4: "cuatro",
      5: "cinco",
      6: "seis",
      7: "siete",
      8: "ocho",
      9: "nueve",
      10: "diez",
    };

    await speak(numberWords[number]!, speedRate: 0.3, pitch: 1.3);
  }

  /// Reproduce una letra del alfabeto
  Future<void> speakLetter(String letter) async {
    await speak(letter.toLowerCase(), speedRate: 0.3, pitch: 1.3);
  }

  /// Reproduce una sílaba
  Future<void> speakSyllable(String syllable) async {
    await speak(syllable.toLowerCase(), speedRate: 0.3, pitch: 1.2);
  }

  /// Reproduce mensajes de felicitación para niños
  Future<void> speakCelebration() async {
    final celebrations = [
      "¡Muy bien!",
      "¡Excelente!",
      "¡Fantástico!",
      "¡Eres increíble!",
      "¡Genial!",
    ];

    final randomCelebration =
        celebrations[DateTime.now().millisecond % celebrations.length];
    await speak(randomCelebration, speedRate: 0.4, pitch: 1.4);
  }

  /// Reproduce mensajes de ánimo
  Future<void> speakEncouragement() async {
    final encouragements = [
      "¡Inténtalo de nuevo!",
      "¡Tú puedes!",
      "¡Sigue intentando!",
      "¡Casi lo tienes!",
    ];

    final randomEncouragement =
        encouragements[DateTime.now().millisecond % encouragements.length];
    await speak(randomEncouragement, speedRate: 0.4, pitch: 1.1);
  }

  /// Detiene la reproducción actual
  Future<void> stop() async {
    if (!_isInitialized) return;

    try {
      await _flutterTts.stop();
      _isPlaying = false;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error deteniendo TTS: $e");
      }
    }
  }

  /// Pausa la reproducción
  Future<void> pause() async {
    if (!_isInitialized) return;

    try {
      await _flutterTts.pause();
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error pausando TTS: $e");
      }
    }
  }

  /// Verifica si está reproduciendo actualmente
  bool get isPlaying => _isPlaying;

  /// Verifica si el servicio está inicializado
  bool get isInitialized => _isInitialized;

  /// Obtiene las voces disponibles en el dispositivo
  Future<List<dynamic>> getAvailableVoices() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      return await _flutterTts.getVoices ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error obteniendo voces: $e");
      }
      return [];
    }
  }

  /// Establece una voz específica
  Future<void> setVoice(Map<String, String> voice) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      await _flutterTts.setVoice(voice);
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error estableciendo voz: $e");
      }
    }
  }

  /// Limpia recursos al cerrar la aplicación
  Future<void> dispose() async {
    if (_isInitialized) {
      await stop();
      _isInitialized = false;
    }
  }
}
