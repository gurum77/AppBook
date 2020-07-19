import 'package:flutter/material.dart';

class HomePageBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 왼쪽의 작은 원
    canvas.drawCircle(
        Offset(0, 0), size.height / 3, Paint()..color = Colors.red[50]);
    // 오른쪽의 큰 원
    canvas.drawCircle(Offset(size.width / 1.2, -size.height / 4),
        size.height / 1.5, Paint()..color = Colors.red[100]);
        
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
