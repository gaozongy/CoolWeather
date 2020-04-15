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

  @override
  void initState() {
    super.initState();

    //                            radius, startAngle, sweepAngle, strokeWidth, color, speed);
    // 1
    starTrailsList.add(StarTrails(400, 0, 7, 1.4, Color(0xFF82ECE1), 0));
    // 2
    starTrailsList.add(StarTrails(420, 0, 0.25, 1.4, Color(0xFFD0FCFB), 0.006));
    starTrailsList.add(StarTrails(420, 3, 0.25, 1.4, Color(0xFFD0FCFB), 0.006));
    // 3
    starTrailsList.add(StarTrails(440, 0, 7, 1, Color(0xFF739698), 0));
    // 4
    starTrailsList.add(StarTrails(475, 0, 0.25, 2, Color(0xFFFFFFFF), 0.005));
    starTrailsList.add(StarTrails(475, 3, 0.25, 2, Color(0xFFFFFFFF), 0.005));
    // 5
    starTrailsList.add(StarTrails(490, 0, 7, 1, Color(0xFF739698), 0));

    // 6
    starTrailsList.add(StarTrails(530, 0, 7, 1.5, Color(0xFFC8FFF9), 0));
    // 7
    starTrailsList.add(StarTrails(560, 1, 0.25, 1.4, Color(0xFF7FE7DE), 0.004));
    starTrailsList.add(StarTrails(560, 4, 0.25, 1.4, Color(0xFF7FE7DE), 0.004));
    // 8
    starTrailsList.add(StarTrails(570, 0, 7, 1.5, Color(0xFFC8FFF9), 0));
    // 9
    starTrailsList.add(StarTrails(580, 2, 0.5, 2, Color(0xFFFFFFFF), 0.008));
    starTrailsList.add(StarTrails(580, 5, 0.5, 2, Color(0xFFFFFFFF), 0.008));
    // 10
    starTrailsList.add(StarTrails(585, 3, 0.5, 1.2, Color(0xFFC8FFF9), 0.01));
    starTrailsList.add(StarTrails(585, 5, 0.5, 1.2, Color(0xFFC8FFF9), 0.01));
    // 11
    starTrailsList.add(StarTrails(598, 0, 7, 1, Color(0xFF7FE7DE), 0));

//    starTrailsList.add(StarTrails(620, 0, 7, 1, Color(0xFF84EADF), 0));
//    starTrailsList.add(StarTrails(640, 0, 7, 1, Color(0xFF739698), 0));
//    starTrailsList.add(StarTrails(660, 0, 7, 1, Color(0xFF739698), 0));
//    starTrailsList.add(StarTrails(680, 0, 7, 1, Color(0xFFCAFFF9), 0));
//    starTrailsList.add(StarTrails(700, 0, 7, 1, Color(0xFFCAFFF9), 0));
//    starTrailsList.add(StarTrails(720, 0, 7, 1, Color(0xFF739698), 0));
//    starTrailsList.add(StarTrails(740, 0, 7, 1, Color(0xFF83EBE0), 0));
//    starTrailsList.add(StarTrails(760, 0, 7, 1, Color(0xFFFFFFFF), 0));
//    starTrailsList.add(StarTrails(780, 0, 7, 1, Color(0xFF739698), 0));
//    starTrailsList.add(StarTrails(800, 0, 7, 1, Color(0xFF739698), 0));
//    starTrailsList.add(StarTrails(820, 0, 7, 1, Color(0xFF739698), 0));
//    starTrailsList.add(StarTrails(840, 0, 7, 1, Color(0xFF739698), 0));
//    starTrailsList.add(StarTrails(860, 0, 7, 1, Color(0xFF739698), 0));
//    starTrailsList.add(StarTrails(880, 0, 7, 1, Color(0xFF739698), 0));

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

Paint starTrailsPaint = new Paint()..style = PaintingStyle.stroke;

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
      starTrailsPaint.color = starTrails.color;
      starTrailsPaint.strokeWidth = starTrails.strokeWidth;
      starTrails.startAngle = starTrails.startAngle + starTrails.speed;
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
  double strokeWidth;
  Color color;
  double speed;

  StarTrails(this.radius, this.startAngle, this.sweepAngle, this.strokeWidth,
      this.color, this.speed);
}
