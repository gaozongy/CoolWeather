import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SunnyAnim extends StatefulWidget {
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
          painter: SunnyPainter(radians)),
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

  SunnyPainter(this.radians);

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    drawLight(6, 12, radToDeg(-radians * 2), Colors.white24, 200, 330, canvas);

    drawLight(6, 18, radToDeg(-radians * 2), Colors.white24, 180, 420, canvas);

    drawLight(6, 25, radToDeg(-radians * 2), Colors.white24, 165, 490, canvas);

    drawLight(6, 30, radToDeg(-radians * 2), Colors.white24, 150, 580, canvas);

    canvas.translate(width / 2, -120);
    canvas.rotate(radians);

    double radius6 = 380;
    drawSun(mEdgeSize, radius6, -70, Color(0xFF93C3B5), canvas);

    double radius5 = 330;
    drawSun(mEdgeSize, radius5, -50, Color(0xFFB9C583), canvas);

    double radius4 = 290;
    drawSun(mEdgeSize, radius4, -45, Color(0xFFCEB860), canvas);

    double radius3 = 240;
    drawSun(mEdgeSize, radius3, -25, Color(0xFFD6A44C), canvas);

    double radius2 = 190;
    drawSun(mEdgeSize, radius2, -10, Color(0xFFD98E43), canvas);

    double radius1 = 150;
    drawSun(mEdgeSize, radius1, 0, Color(0xFFD77B3B), canvas);
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
