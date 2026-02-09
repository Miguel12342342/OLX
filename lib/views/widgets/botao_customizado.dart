import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  const BotaoCustomizado({
    super.key,
    required this.texto,
    this.corTexto = Colors.white,
    required this.onPressed,
  });

  final String texto;
  final Color corTexto;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(6),
        ),
        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        backgroundColor: Color(0xff9c27b0),
      ),
      onPressed: onPressed,
      child: Text(texto, style: TextStyle(color: corTexto, fontSize: 20)),
    );
  }
}
