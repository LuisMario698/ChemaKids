import 'package:flutter/material.dart';
import '../widgets/fondo_menu_abc.dart';
import '../widgets/tema_juego_chemakids.dart';

/// Ejemplo de cómo aplicar el fondo ABC a otros juegos
/// Este archivo muestra diferentes formas de usar los elementos visuales del ABC
class EjemploFondosABC extends StatelessWidget {
  const EjemploFondosABC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplos de Fondos ABC'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ejemplos de Fondos basados en el Juego ABC',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Ejemplo 1: Fondo completo para menú
            _buildEjemplo(
              titulo: '1. Fondo Completo de Menú',
              descripcion: 'Fondo principal del menú con animaciones completas',
              child: Container(
                height: 200,
                child: FondoMenuABC(
                  intensidad: 0.8,
                  child: const Center(
                    child: Text(
                      'Menú Principal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Ejemplo 2: Fondo mini para tarjetas
            _buildEjemplo(
              titulo: '2. Fondo Mini para Tarjetas',
              descripcion: 'Versión simplificada para elementos más pequeños',
              child: FondoMenuABCMini(
                altura: 120,
                child: const Center(
                  child: Text(
                    'Tarjeta ABC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            
            // Ejemplo 3: Solo gradiente ABC
            _buildEjemplo(
              titulo: '3. Solo Gradiente ABC',
              descripcion: 'Usando únicamente el gradiente sin animaciones',
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: EfectosABC.crearGradienteABC(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Gradiente Estático',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            
            // Ejemplo 4: Combinación con plantilla de juego
            _buildEjemplo(
              titulo: '4. Combinado con Plantilla de Juego',
              descripcion: 'Fondo ABC + Plantilla de juego ChemaKids',                child: Container(
                height: 250,
                child: PlantillaJuegoChemaKids(
                  titulo: 'Juego con Fondo ABC',
                  icono: Icons.games,
                  contenido: Container(
                    decoration: BoxDecoration(
                      gradient: EfectosABC.crearGradienteABC(rotacion: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.all(20),
                    child: const Center(
                      child: Text(
                        'Contenido del Juego\ncon estilo ABC',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Ejemplo 5: Elementos decorativos
            _buildEjemplo(
              titulo: '5. Elementos Decorativos ABC',
              descripcion: 'Círculos decorativos individuales',
              child: Container(
                height: 120,
                color: Colors.grey[100],
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 20,
                      child: EfectosABC.crearCirculoABC(
                        tamano: 60,
                        opacidad: 0.4,
                        color: EfectosABC.coloresPrincipales[0],
                      ),
                    ),
                    Positioned(
                      top: 30,
                      right: 30,
                      child: EfectosABC.crearCirculoABC(
                        tamano: 40,
                        opacidad: 0.3,
                        color: EfectosABC.coloresSecundarios[0],
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Elementos Decorativos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Ejemplo 6: Paleta de colores
            _buildEjemplo(
              titulo: '6. Paleta de Colores ABC',
              descripcion: 'Colores disponibles en el tema ABC',
              child: Column(
                children: [
                  const Text('Colores Principales:'),
                  Row(
                    children: EfectosABC.coloresPrincipales.map((color) {
                      return Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  const Text('Colores Secundarios:'),
                  Row(
                    children: EfectosABC.coloresSecundarios.map((color) {
                      return Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEjemplo({
    required String titulo,
    required String descripcion,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            descripcion,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ejemplo específico: Aplicar fondo ABC a un juego existente
class JuegoConFondoABC extends StatelessWidget {
  const JuegoConFondoABC({super.key});

  @override
  Widget build(BuildContext context) {
    return FondoMenuABC(
      intensidad: 0.7, // Reducir intensidad para no distraer del juego
      child: SafeArea(
        child: Column(
          children: [
            // Header del juego
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Juego con Estilo ABC',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.help, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            // Contenido del juego
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Aquí va el contenido del juego\n\n'
                    'El fondo ABC crea una atmósfera\n'
                    'consistente con el resto de la app',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
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

/// Guía de migración para aplicar fondo ABC a juegos existentes
/// 
/// ANTES (juego típico):
/// ```dart
/// Scaffold(
///   body: Container(
///     decoration: BoxDecoration(
///       gradient: LinearGradient(colors: [...]),
///     ),
///     child: SafeArea(child: ...),
///   ),
/// )
/// ```
/// 
/// DESPUÉS (con fondo ABC):
/// ```dart
/// FondoMenuABC(
///   intensidad: 0.6, // Reducir para juegos
///   child: SafeArea(child: ...),
/// )
/// ```
/// 
/// BENEFICIOS:
/// - Consistencia visual con el menú
/// - Animaciones suaves y profesionales  
/// - Paleta de colores unificada
/// - Elementos reconocibles del juego ABC
