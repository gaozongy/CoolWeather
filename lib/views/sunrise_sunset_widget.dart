import 'package:flutter/material.dart';

/// 日出日落
class SunriseSunsetWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(0, 80), painter: SunriseSunsetPainter());
  }
}

class SunriseSunsetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}