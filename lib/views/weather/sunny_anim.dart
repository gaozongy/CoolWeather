import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SunnyAnim extends StatefulWidget {
  final double maskAlpha;

  SunnyAnim(this.maskAlpha);

  @override
  _SunnyAnimState createState() => _SunnyAnimState();
}

class _SunnyAnimState extends State<SunnyAnim> with TickerProviderStateMixin {
  AnimationController controller;

  double radians = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(days: 1),
    )..addListener(() {
        setState(() {
          radians += 0.006;
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
          size: Size(double.infinity, double.infinity),
          painter: SunnyPainter(radians, widget.maskAlpha)),
      decoration: BoxDecoration(color: Color(0xFF4A97D2)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

class SunnyPainter extends CustomPainter {
  double radians;

  int mEdgeSize = 11;

  double maskAlpha;

  SunnyPainter(this.radians, this.maskAlpha);

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    Color lightColor = Color.fromARGB((61 * maskAlpha).toInt(), 255, 255, 255);

    drawLight(6, 12, radToDeg(-radians * 2), lightColor, 200, 330, canvas);

    drawLight(6, 18, radToDeg(-radians * 2), lightColor, 180, 420, canvas);

    drawLight(6, 25, radToDeg(-radians * 2), lightColor, 165, 490, canvas);

    drawLight(6, 30, radToDeg(-radians * 2), lightColor, 150, 580, canvas);

    canvas.translate(width / 2, -120);
    canvas.rotate(radians);

    double radius6 = 380;
    drawSun(mEdgeSize, radius6, -70, Color.fromARGB((255 * maskAlpha).toInt(), 147, 195, 181), canvas);

    double radius5 = 330;
    drawSun(mEdgeSize, radius5, -50, Color.fromARGB((255 * maskAlpha).toInt(), 185, 197, 131), canvas);

    double radius4 = 290;
    drawSun(mEdgeSize, radius4, -45, Color.fromARGB((255 * maskAlpha).toInt(), 206, 184, 96), canvas);

    double radius3 = 240;
    drawSun(mEdgeSize, radius3, -25, Color.fromARGB((255 * maskAlpha).toInt(), 214, 164, 76), canvas);

    double radius2 = 190;
    drawSun(mEdgeSize, radius2, -10, Color.fromARGB((255 * maskAlpha).toInt(), 217, 142, 67), canvas);

    double radius1 = 150;
    drawSun(mEdgeSize, radius1, 0, Color.fromARGB((255 * maskAlpha).toInt(), 215, 123, 59), canvas);
  }

  void drawSun(int edgeSize, double radius, double startAngle, Color color,
      Canvas canvas) {
    List<Coordinate> coordinate = new List();
    for (int i = 0; i < edgeSize; i++) {
      double angle = 360 / edgeSize * i + startAngle;
      double x1 = sin(degToRad(angle)) * radius;
      double y1 = cos(degToRad(angle)) * radius;
      coordinate.add(Coordinate(cx: x1, cy: y1));
    }

    Paint paint = Paint()..color = color;

    Path path = new Path();
    path.moveTo(coordinate.elementAt(0).cx, coordinate.elementAt(0).cy);

    coordinate.forEach((pot) {
      path.lineTo(pot.cx, pot.cy);
    });

    path.close();

    canvas.drawPath(path, paint);
  }

  void drawLight(int edgeSize, double radius, double startAngle, Color color,
      double dx, double dy, Canvas canvas) {
    List<Coordinate> coordinate = new List();
    for (int i = 0; i < edgeSize; i++) {
      double angle = 360 / edgeSize * i + startAngle;
      double x1 = sin(degToRad(angle)) * radius + dx;
      double y1 = cos(degToRad(angle)) * radius + dy;
      coordinate.add(Coordinate(cx: x1, cy: y1));
    }

    Paint paint = Paint()..color = color;

    Path path = new Path();
    path.moveTo(coordinate.elementAt(0).cx, coordinate.elementAt(0).cy);

    coordinate.forEach((pot) {
      path.lineTo(pot.cx, pot.cy);
    });

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Coordinate {
  final double cx;
  final double cy;

  Coordinate({this.cx, this.cy});
}

num degToRad(num deg) => deg * (pi / 180.0);

num radToDeg(num rad) => rad * (180.0 / pi);
