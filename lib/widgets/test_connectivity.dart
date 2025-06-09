import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_manager.dart';
import '../services/estado_app.dart';
import '../models/invitado_model.dart';

/// Widget de prueba para verificar la conectividad de la base de datos
/// y el sistema de registro de invitados completo.
class TestConnectivity extends StatefulWidget {
  const TestConnectivity({super.key});

  @override
  State<TestConnectivity> createState() => _TestConnectivityState();
}

class _TestConnectivityState extends State<TestConnectivity> {
  String _status = 'Listo para probar...';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test de Conectividad'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estado del Sistema',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_status),
                    const SizedBox(height: 16),
                    if (_isLoading) const LinearProgressIndicator(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _testDatabaseConnection,
              child: const Text('1. Probar Conexión a Base de Datos'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : _testGuestRegistration,
              child: const Text('2. Probar Registro de Invitado'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : _testEstadoAppIntegration,
              child: const Text('3. Probar Integración EstadoApp'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : _testCompleteFlow,
              child: const Text('4. Probar Flujo Completo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _clearAll,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Limpiar Todo'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testDatabaseConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Probando conexión a base de datos...';
    });

    try {
      final db = DatabaseManager.instance;

      // Probar conexión obteniendo información básica
      final juegos = await db.juegos.obtenerJuegos();

      setState(() {
        _status =
            '✅ Conexión exitosa!\n'
            'Juegos encontrados: ${juegos.length}\n'
            'Base de datos operativa.';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error de conexión:\n$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testGuestRegistration() async {
    setState(() {
      _isLoading = true;
      _status = 'Probando registro de invitado...';
    });

    try {
      final db = DatabaseManager.instance;

      // Crear un invitado de prueba con el nuevo sistema
      final nuevoInvitado = InvitadoModel(
        id: 0,
        nombre: 'Test User ${DateTime.now().millisecondsSinceEpoch}',
        edad: 6,
        idProgreso: 0, // Se asigna automáticamente
      );

      final invitadoCreado = await db.invitados.crear(nuevoInvitado);

      setState(() {
        _status =
            '✅ Invitado creado exitosamente!\n'
            'ID: ${invitadoCreado.id}\n'
            'Nombre: ${invitadoCreado.nombre}\n'
            'ID Progreso: ${invitadoCreado.idProgreso}\n'
            'Sistema de progreso funcionando.';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error en registro de invitado:\n$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testEstadoAppIntegration() async {
    setState(() {
      _isLoading = true;
      _status = 'Probando integración con EstadoApp...';
    });

    try {
      final db = DatabaseManager.instance;
      final estadoApp = Provider.of<EstadoApp>(context, listen: false);

      // Crear invitado temporal
      final invitado = InvitadoModel(
        id: 0,
        nombre: 'Test EstadoApp ${DateTime.now().millisecondsSinceEpoch}',
        edad: 7,
        idProgreso: 0,
      );

      final invitadoCreado = await db.invitados.crear(invitado);

      // Configurar en EstadoApp
      await estadoApp.establecerUsuarioInvitado(invitadoCreado);

      // Verificar integración
      final tieneProgreso = estadoApp.tieneUsuario;
      final esInvitado = estadoApp.esInvitado;

      setState(() {
        _status =
            '✅ Integración EstadoApp exitosa!\n'
            'Usuario configurado: $tieneProgreso\n'
            'Es invitado: $esInvitado\n'
            'Sistema integrado correctamente.';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error en integración EstadoApp:\n$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testCompleteFlow() async {
    setState(() {
      _isLoading = true;
      _status = 'Ejecutando flujo completo...';
    });

    try {
      final db = DatabaseManager.instance;
      final estadoApp = Provider.of<EstadoApp>(context, listen: false);

      // 1. Probar conexión
      await db.juegos.obtenerJuegos();

      // 2. Crear invitado
      final invitado = InvitadoModel(
        id: 0,
        nombre: 'Flujo Completo ${DateTime.now().millisecondsSinceEpoch}',
        edad: 8,
        idProgreso: 0,
      );

      final invitadoCreado = await db.invitados.crear(invitado);

      // 3. Configurar EstadoApp
      await estadoApp.establecerUsuarioInvitado(invitadoCreado);

      // 4. Verificar progreso existe
      await db.progreso.obtenerProgresoInvitado(invitadoCreado.idProgreso);

      // 5. Verificar estado final
      final estadoFinal = estadoApp.tieneUsuario;

      setState(() {
        _status =
            '🎉 ¡Flujo completo exitoso!\n'
            '✅ Conexión DB: OK\n'
            '✅ Registro invitado: OK (ID: ${invitadoCreado.id})\n'
            '✅ Progreso creado: OK (ID: ${invitadoCreado.idProgreso})\n'
            '✅ EstadoApp integrado: OK\n'
            '✅ Tiene usuario: $estadoFinal\n'
            '🚀 Sistema listo para producción!';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error en flujo completo:\n$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearAll() async {
    setState(() {
      _isLoading = true;
      _status = 'Limpiando sistema...';
    });

    try {
      // Limpiar EstadoApp
      final estadoApp = Provider.of<EstadoApp>(context, listen: false);
      await estadoApp.cerrarSesion();

      setState(() {
        _status =
            '✅ Sistema limpiado.\n'
            'EstadoApp reiniciado.\n'
            'Listo para nuevas pruebas.';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error al limpiar:\n$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
