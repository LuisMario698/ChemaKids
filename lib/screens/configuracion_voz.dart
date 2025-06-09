import 'package:flutter/material.dart';
import '../services/tts_service.dart';

class ConfiguracionVoz extends StatefulWidget {
  const ConfiguracionVoz({super.key});

  @override
  State<ConfiguracionVoz> createState() => _ConfiguracionVozState();
}

class _ConfiguracionVozState extends State<ConfiguracionVoz> {
  final TTSService _ttsService = TTSService();
  List<Map<String, String>> _voicesAvailable = [];
  Map<String, String>? _selectedVoice;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVoices();
  }

  Future<void> _loadVoices() async {
    try {
      await _ttsService.initialize();
      final voices = await _ttsService.getSpanishVoices();

      setState(() {
        _voicesAvailable = voices;
        _isLoading = false;
      });

      if (voices.isEmpty) {
        _showNoVoicesDialog();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog();
    }
  }

  void _showNoVoicesDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sin voces disponibles'),
            content: const Text(
              'No se encontraron voces en español en este dispositivo.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('No se pudieron cargar las voces disponibles.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> _testVoice(Map<String, String> voice) async {
    try {
      await _ttsService.setVoice(voice);
      await _ttsService.speakLetter('A');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error probando voz: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _setVoice(Map<String, String> voice) async {
    try {
      await _ttsService.setVoice(voice);
      setState(() {
        _selectedVoice = voice;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voz cambiada a: ${voice['name']}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error estableciendo voz: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A0944),
      appBar: AppBar(
        title: const Text(
          'Configuración de Voz',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2A0944),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Cargando voces disponibles...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              )
              : _voicesAvailable.isEmpty
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.voice_over_off, size: 80, color: Colors.white54),
                    SizedBox(height: 16),
                    Text(
                      'No hay voces en español disponibles',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info, color: Colors.amber, size: 24),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Selecciona una voz y pruébala tocando el botón de prueba.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Voces disponibles:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _voicesAvailable.length,
                        itemBuilder: (context, index) {
                          final voice = _voicesAvailable[index];
                          final isSelected = _selectedVoice == voice;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            color:
                                isSelected
                                    ? Colors.green.withOpacity(0.3)
                                    : Colors.white.withOpacity(0.1),
                            child: ListTile(
                              leading: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.record_voice_over,
                                color: isSelected ? Colors.green : Colors.white,
                              ),
                              title: Text(
                                voice['name'] ?? 'Voz desconocida',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                voice['locale'] ?? '',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Botón de prueba
                                  IconButton(
                                    onPressed: () => _testVoice(voice),
                                    icon: const Icon(Icons.play_circle_fill),
                                    color: Colors.blue,
                                    tooltip: 'Probar voz',
                                  ),
                                  // Botón de seleccionar
                                  if (!isSelected)
                                    IconButton(
                                      onPressed: () => _setVoice(voice),
                                      icon: const Icon(Icons.check),
                                      color: Colors.green,
                                      tooltip: 'Seleccionar voz',
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Botón para establecer la mejor voz automáticamente
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await _ttsService.setBestVoiceForChildren();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Voz automática configurada'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        icon: const Icon(Icons.auto_fix_high),
                        label: const Text('Configurar Voz Automática'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
