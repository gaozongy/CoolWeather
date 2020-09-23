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

  List<Color> trailsColorList = [
    Color(0xFFFFFFFF),
    Color(0xFFD0FCFB),
    Color(0xFFCAFFF9),
    Color(0xFFC8FFF9),
    Color(0xFF94E3E0),
    Color(0xFF8DE6E0),
    Color(0xFF84EADF),
    Color(0xFF83EBE0),
    Color(0xFF749799),
    Color(0xFF739698)
  ];

  Color bgColor = Color(0xFF061324);

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 40; i++) {
      double radius = 400 + 20 * (i - 1) + Random().nextDouble() * 18;
      if (i > 22) {
        radius = radius + 60 * (i - 22);
      }
      double startAngle = Random().nextDouble() * pi * 2;
      double sweepAngle = pi / 2 + Random().nextDouble() * pi / 2;
      double speed = (Random().nextInt(10) + 2) / 1000;
      if (Random().nextDouble() < 0.85) {
        double strokeWidth = Random().nextDouble() * 1.2 + 1;
        int colorIndex = Random().nextInt(trailsColorList.length - 1);
        starTrailsList.add(StarTrails(radius, startAngle, sweepAngle,
            strokeWidth, trailsColorList[colorIndex], speed));
        starTrailsList.add(StarTrails(radius, startAngle + pi, sweepAngle,
            strokeWidth, trailsColorList[colorIndex], speed));
      } else {
        double strokeWidth = 2.2;
        int colorIndex = 0;
        starTrailsList.add(StarTrails(radius, startAngle, pi / 18, strokeWidth,
            trailsColorList[colorIndex], speed));
        starTrailsList.add(StarTrails(radius, startAngle + pi / 2, pi / 16,
            strokeWidth, trailsColorList[colorIndex], speed));
        starTrailsList.add(StarTrails(radius, startAngle + pi, pi / 17,
            strokeWidth, trailsColorList[colorIndex], speed));
        starTrailsList.add(StarTrails(radius, startAngle + pi * 3 / 2, pi / 15,
            strokeWidth, trailsColorList[colorIndex], speed));
      }
    }

    controller = AnimationController(
      vsync: this,
      duration: Duration(days: 1),
    )..addListener(() {
        setState(() {
          radians += 0.001;
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
      decoration: BoxDecoration(color: bgColor),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

class SunnyNightPainter extends CustomPainter {
  double radians;

  double maskAlpha;

  List<StarTrails> starTrailsList;

  Paint starTrailsPaint = new Paint()..style = PaintingStyle.stroke;

  SunnyNightPainter(this.radians, this.maskAlpha, this.starTrailsList);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-350, -130);
    canvas.rotate(radians);

    starTrailsList.forEach((starTrails) {
      starTrailsPaint.color = calculateColor(starTrails.color);
      starTrailsPaint.strokeWidth = starTrails.strokeWidth;
      starTrails.startAngle = starTrails.startAngle + starTrails.speed;
      canvas.drawArc(
          Rect.fromCircle(center: Offset(0, 0), radius: starTrails.radius),
          starTrails.startAngle,
          starTrails.sweepAngle,
          false,
          starTrailsPaint);
    });
  }

  Color calculateColor(Color color) {
    int alpha = (255 * maskAlpha).toInt();
    return Color.fromARGB(alpha, color.red, color.green, color.blue);
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
  double strokeWidth;
  Color color;
  double speed;

  StarTrails(this.radius, this.startAngle, this.sweepAngle, this.strokeWidth,
      this.color, this.speed);
}
