// DIBUJO DE LA GRÁFICA DE VENTAS EN EL DASHBOARD

import 'package:flutter/material.dart';

class SalesChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFCC00) // El amarillo de ElectroSoft
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    // Dibujamos una curva similar a la de la captura
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.2, size.height * 0.8, 
      size.width * 0.4, size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.6, size.height * 0.2, 
      size.width * 0.8, size.height * 0.4,
    );
    path.lineTo(size.width, size.height * 0.1);

    // Añadimos una sombra debajo de la línea (opcional para más realismo)
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}