import 'package:flutter/material.dart';

class CloudyPainter extends CustomPainter {
  Paint cloudPaint = new Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.white38;

  Paint sunPaint = new Paint()
    ..style = PaintingStyle.fill
    ..color = Color(0xE6E8CF2D);

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    print('width:' + width.toString() + ' height:' + height.toString());

    canvas.drawCircle(Offset(width - 60, 120), 100, cloudPaint);

    canvas.drawCircle(Offset(width / 2, 20), 170, cloudPaint);

    canvas.drawCircle(Offset(width / 5 * 3, 140), 50, sunPaint);


    canvas.drawCircle(Offset(width / 5 * 3.6, -30), 170, cloudPaint);
    canvas.drawCircle(Offset(width / 5 * 3.6 - 10, -50), 170, cloudPaint);

    canvas.drawCircle(Offset(30, -50), 150, cloudPaint);
    canvas.drawCircle(Offset(35, -100), 160, cloudPaint);

    canvas.drawCircle(Offset(width / 5 * 1.5, -40), 210, cloudPaint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
