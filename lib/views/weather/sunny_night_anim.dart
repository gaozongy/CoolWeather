import 'package:coolweather/views/weather/sunny_night_paint.dart';
import 'package:flutter/material.dart';

class SunnyNightAnim extends StatefulWidget {
  @override
  _SunnyNightAnimState createState() => _SunnyNightAnimState();
}

class _SunnyNightAnimState extends State<SunnyNightAnim>
    with TickerProviderStateMixin {

  AnimationController controller;

  double radians = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(days: 365 * 999),
    )..addListener(() {
      setState(() {
        radians += 0.01;
      });
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: CustomPaint(painter: SunnyNightPainter(radians)));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
