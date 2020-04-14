import 'dart:math';

import 'package:flutter/material.dart';

import 'base_weather_state.dart';

class SunnyNightAnim extends StatefulWidget {
  SunnyNightAnim({Key key}) : super(key: key);

  @override
  _SunnyNightAnimState createState() => _SunnyNightAnimState();
}

class _SunnyNightAnimState extends BaseAnimState<SunnyNightAnim> {
  AnimationController controller;

  double radians = 0;

  List<StarTrails> starTrailsList = List();

  List<int> colors = [
    0xFF8DE6E0,
    0xFFD0FCFB,
    0xFF739698,
    0xFF749799,
    0xFFC8FFF9,
    0xFF84EADF,
    0xFFCAFFF9,
    0xFFFFFFFF,
    0xFFCAFFF9,
    0xFF94E3E0,
    0xFFFFFFFF,
    0xFF84EADF,
    0xFF739698,
    0xFF739698,
    0xFFCAFFF9,
    0xFFCAFFF9,
    0xFF739698,
    0xFF83EBE0,
    0xFFFFFFFF,
    0xFF739698,
    0xFF739698,
    0xFF739698,
    0xFF739698,
    0xFF739698,
    0xFF739698
  ];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 25; i++) {
      double radius = 400 + 30 * i + Random().nextDouble() * 30;
      double startAngle = Random().nextDouble() * 6;
      double sweepAngle = Random().nextDouble() * 5;
      double strokeWidth = 1 + Random().nextDouble() * 1.5;
      if(i % 3 == 0) {
        sweepAngle = Random().nextDouble();
      }
      if (i < 6) {
        sweepAngle += 2.4;
      } else if (i < 12) {
        sweepAngle += 1.2;
      }
      starTrailsList.add(StarTrails(radius, startAngle, sweepAngle,
          colors.elementAt(i), 6 - sweepAngle, strokeWidth));
    }

    controller = AnimationController(
      vsync: this,
      duration: Duration(days: 1),
    )..addListener(() {
        setState(() {
          radians += 0.01;
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
          size: Size(double.infinity, double.infinity),
          painter: SunnyNightPainter(radians, maskAlpha, starTrailsList)),
      decoration: BoxDecoration(color: Color(0xFF061324)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

Paint maskPaint = new Paint()
  ..style = PaintingStyle.fill
  ..color = Color(0xFF061324);

Paint starTrailsPaint = new Paint()
  ..style = PaintingStyle.stroke;

Offset offset = Offset(0, 0);

class SunnyNightPainter extends CustomPainter {
  double radians;

  double maskAlpha;

  List<StarTrails> starTrailsList;

  SunnyNightPainter(this.radians, this.maskAlpha, this.starTrailsList);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-350, -130);
    canvas.rotate(radians);

//    calculateColor();

    starTrailsList.forEach((starTrails) {
      starTrailsPaint.color = Color(starTrails.color);
      starTrailsPaint.strokeWidth = starTrails.strokeWidth;
      starTrails.startAngle = starTrails.startAngle + starTrails.speed / 500;
      canvas.drawArc(Rect.fromCircle(center: offset, radius: starTrails.radius),
          starTrails.startAngle, starTrails.sweepAngle, false, starTrailsPaint);
    });
  }

  void calculateColor() {
    int alpha = (255 * maskAlpha).toInt();
    starTrailsPaint..color = Color.fromARGB(alpha, 208, 252, 251);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class StarTrails {
  double radius;
  double startAngle;
  double sweepAngle;
  int color;
  double speed;
  double strokeWidth;

  StarTrails(this.radius, this.startAngle, this.sweepAngle, this.color,
      this.speed, this.strokeWidth);
}
