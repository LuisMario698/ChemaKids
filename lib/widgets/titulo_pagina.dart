import 'package:flutter/material.dart';

class TituloPagina extends StatelessWidget {
  final String texto;
  final double? fontSize;
  final EdgeInsets? padding;

  const TituloPagina({
    super.key,
    required this.texto,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: fontSize ?? (MediaQuery.of(context).size.width > 600 ? 48 : 40),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
