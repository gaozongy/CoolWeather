import 'package:flutter/material.dart';

class Cloud {
  double dx;
  double dy;

  Cloud(this.dx, this.dy);
}

class CloudyPainter extends CustomPainter {
  List cloudy;

  CloudyPainter(this.cloudy);

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

    canvas.drawCircle(
        Offset(
            width - 60 - cloudy.elementAt(0).x, 120 + cloudy.elementAt(0).y),
        100,
        cloudPaint);

    canvas.drawCircle(
        Offset(width / 2 - cloudy.elementAt(1).x, 20 - cloudy.elementAt(1).y),
        170,
        cloudPaint);

    canvas.drawCircle(Offset(width / 5 * 3, 140), 50, sunPaint);

    canvas.drawCircle(
        Offset(width / 5 * 3.6 + cloudy.elementAt(2).x,
            -20 - cloudy.elementAt(2).y),
        170,
        cloudPaint);

    canvas.drawCircle(
        Offset(width / 5 * 3.6 - 10 + cloudy.elementAt(3).x,
            -50 + cloudy.elementAt(3).y),
        170,
        cloudPaint);

    canvas.drawCircle(
        Offset(10 + cloudy.elementAt(4).x, -30 + cloudy.elementAt(4).y),
        180,
        cloudPaint);

    canvas.drawCircle(
        Offset(35 - cloudy.elementAt(5).x, -110 + cloudy.elementAt(5).y),
        160,
        cloudPaint);

    canvas.drawCircle(
        Offset(width / 5 * 1.5 + cloudy.elementAt(6).x,
            -40 - cloudy.elementAt(6).y),
        210,
        cloudPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
