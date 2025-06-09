import 'package:flutter/material.dart';

class EstiloInfantil {
  // Paleta de colores vibrantes y divertidos
  static const List<List<Color>> temasColores = [
    [Color(0xFFFF6B6B), Color(0xFFFFE66D)], // Tema Aventura
    [Color(0xFF7FB5FF), Color(0xFFB8E0D2)], // Tema Océano
    [Color(0xFFFFB7D5), Color(0xFFFEE1E8)], // Tema Dulce
    [Color(0xFF95E082), Color(0xFFD4FC79)], // Tema Naturaleza
    [Color(0xFFFFA07A), Color(0xFFFFDAB9)], // Tema Safari
  ];

  // Decoraciones personalizadas
  static BoxDecoration obtenerDecoracionTarjeta(int indice) {
    final colores = temasColores[indice % temasColores.length];
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colores,
      ),
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: colores[0].withOpacity(0.3),
          blurRadius: 15,
          offset: Offset(-5, -5),
        ),
        BoxShadow(
          color: colores[1].withOpacity(0.3),
          blurRadius: 15,
          offset: Offset(5, 5),
        ),
      ],
    );
  }

  // Estilos de texto divertidos
  static TextStyle tituloJuego = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [
      Shadow(
        color: Colors.black26,
        blurRadius: 5,
        offset: Offset(2, 2),
      ),
    ],
  );

  // Animaciones predefinidas
  static Duration duracionAnimacion = Duration(milliseconds: 300);
}
