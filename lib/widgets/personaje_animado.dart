import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class PersonajeAnimado extends StatefulWidget {
  final double? width;
  final double? height;
  
  const PersonajeAnimado({
    super.key,
    this.width,
    this.height,
  });

  @override
  State<PersonajeAnimado> createState() => _PersonajeAnimadoState();
}

class _PersonajeAnimadoState extends State<PersonajeAnimado> {
  SMITrigger? _trigger;

  void _onInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    );
    artboard.addController(controller!);
    _trigger = controller.findSMI('trigger') as SMITrigger;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _trigger?.fire(),
      child: SizedBox(
        width: widget.width ?? 120,
        height: widget.height ?? 120,
        child: RiveAnimation.asset(
          'assets/animaciones/panda.riv',
          stateMachines: const ['State Machine 1'],
          onInit: _onInit,
        ),
      ),
    );
  }
}