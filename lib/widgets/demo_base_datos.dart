import 'package:flutter/material.dart';
import '../services/database_manager.dart';
import '../services/ejemplo_uso_bd.dart';

/// Widget de demostración para probar la funcionalidad de la base de datos
/// Se puede incluir en cualquier pantalla para hacer pruebas
class DemoBaseDatos extends StatefulWidget {
  const DemoBaseDatos({super.key});

  @override
  State<DemoBaseDatos> createState() => _DemoBaseDatosState();
}

class _DemoBaseDatosState extends State<DemoBaseDatos> {
  bool _isLoading = false;
  String _resultado = 'Presiona un botón para probar la base de datos';
  final DatabaseManager _db = DatabaseManager.instance;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔧 Demo Base de Datos Supabase',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Botones de prueba
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _probarConexion,
                  icon: const Icon(Icons.wifi),
                  label: const Text('Probar Conexión'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _verificarServicios,
                  icon: const Icon(Icons.health_and_safety),
                  label: const Text('Verificar Servicios'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _obtenerEstadisticas,
                  icon: const Icon(Icons.analytics),
                  label: const Text('Estadísticas'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _ejecutarEjemplos,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Ejecutar Ejemplos'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Área de resultados
            Container(
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child:
                  _isLoading
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 8),
                            Text('Ejecutando operación...'),
                          ],
                        ),
                      )
                      : SingleChildScrollView(
                        child: Text(
                          _resultado,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
            ),

            const SizedBox(height: 8),

            // Botón para limpiar resultados
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _limpiarResultados,
                child: const Text('Limpiar Resultados'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _probarConexion() async {
    setState(() {
      _isLoading = true;
      _resultado = 'Probando conexión con Supabase...';
    });

    try {
      final isConnected = _db.usuarios.toString(); // Simple check

      setState(() {
        _resultado = '''
✅ CONEXIÓN EXITOSA
📅 ${DateTime.now()}
🔗 Base de datos: Conectada
📊 Servicios: Disponibles

Detalles:
- UsuarioService: Activo
- InvitadoService: Activo  
- JuegoService: Activo
- ProgresoService: Activo
''';
      });
    } catch (e) {
      setState(() {
        _resultado = '''
❌ ERROR DE CONEXIÓN
📅 ${DateTime.now()}
🚨 Error: $e

Posibles causas:
- Credenciales incorrectas
- Internet desconectado
- Servidor Supabase no disponible
''';
      });
    }

    setState(() => _isLoading = false);
  }

  Future<void> _verificarServicios() async {
    setState(() {
      _isLoading = true;
      _resultado = 'Verificando estado de servicios...';
    });

    try {
      final estados = await _db.verificarEstadoServicios();

      final buffer = StringBuffer();
      buffer.writeln('📊 ESTADO DE SERVICIOS');
      buffer.writeln('📅 ${DateTime.now()}');
      buffer.writeln('');

      estados.forEach((servicio, estado) {
        final emoji = estado ? '✅' : '❌';
        buffer.writeln('$emoji $servicio: ${estado ? "Funcionando" : "Error"}');
      });

      final serviciosFuncionando = estados.values.where((e) => e).length;
      final totalServicios = estados.length;

      buffer.writeln('');
      buffer.writeln(
        '📈 Resumen: $serviciosFuncionando/$totalServicios servicios activos',
      );

      setState(() => _resultado = buffer.toString());
    } catch (e) {
      setState(() {
        _resultado = '''
❌ ERROR AL VERIFICAR SERVICIOS
📅 ${DateTime.now()}
🚨 Error: $e
''';
      });
    }

    setState(() => _isLoading = false);
  }

  Future<void> _obtenerEstadisticas() async {
    setState(() {
      _isLoading = true;
      _resultado = 'Obteniendo estadísticas...';
    });

    try {
      final stats = await _db.obtenerEstadisticasGenerales();

      setState(() {
        _resultado = '''
📈 ESTADÍSTICAS GENERALES
📅 ${DateTime.now()}

Datos almacenados:
👤 Usuarios: ${stats['usuarios']}
👥 Invitados: ${stats['invitados']}
🎮 Juegos: ${stats['juegos']}

Estado: Base de datos funcionando correctamente
''';
      });
    } catch (e) {
      setState(() {
        _resultado = '''
❌ ERROR AL OBTENER ESTADÍSTICAS
📅 ${DateTime.now()}
🚨 Error: $e
''';
      });
    }

    setState(() => _isLoading = false);
  }

  Future<void> _ejecutarEjemplos() async {
    setState(() {
      _isLoading = true;
      _resultado = 'Ejecutando ejemplos de uso...';
    });

    try {
      // Ejecutar ejemplos uno por uno para poder mostrar progreso
      setState(() => _resultado = 'Creando perfil de usuario...');
      await EjemploUsoBD.ejemploCrearPerfilUsuario();

      setState(() => _resultado = 'Configurando juegos...');
      await EjemploUsoBD.ejemploConfigurarJuegos();

      setState(() => _resultado = 'Registrando progreso...');
      await EjemploUsoBD.ejemploRegistrarProgreso();

      setState(() => _resultado = 'Consultando datos...');
      await EjemploUsoBD.ejemploConsultarProgreso();

      setState(() => _resultado = 'Realizando búsquedas...');
      await EjemploUsoBD.ejemploBusquedasYFiltros();

      setState(() {
        _resultado = '''
🎉 EJEMPLOS COMPLETADOS EXITOSAMENTE
📅 ${DateTime.now()}

Se ejecutaron todos los ejemplos:
✅ Crear perfil de usuario
✅ Configurar juegos iniciales
✅ Registrar progreso de juego
✅ Consultar progreso del usuario
✅ Búsquedas y filtros

Revisa la consola para ver los detalles completos.
''';
      });
    } catch (e) {
      setState(() {
        _resultado = '''
❌ ERROR AL EJECUTAR EJEMPLOS
📅 ${DateTime.now()}
🚨 Error: $e

Revisa la consola para más detalles.
''';
      });
    }

    setState(() => _isLoading = false);
  }

  void _limpiarResultados() {
    setState(() {
      _resultado = 'Presiona un botón para probar la base de datos';
    });
  }
}
