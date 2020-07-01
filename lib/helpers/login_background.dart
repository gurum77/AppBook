import 'package:flutter/material.dart';

class LoginBackground extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(size.width*0.5, size.height*0.2), size.height*0.5, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}