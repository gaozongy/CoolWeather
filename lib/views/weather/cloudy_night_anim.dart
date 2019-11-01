import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cloudy_paint.dart';

class Star {
  double x;
  double y;
  Color color;

  Star(this.x, this.y, this.color);
}

class CloudyNightAnim extends StatefulWidget {
  @override
  _CloudyNightState createState() => _CloudyNightState();
}

class _CloudyNightState extends State<CloudyNightAnim>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animationX;
  Animation<double> animationY;

  List<Cloud> cloudy = [];
  List<Star> star = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 7; i++) {
      cloudy.add(Cloud(0, 0));
    }

    for (int i = 0; i < 80; i++) {
      Color color = Colors.white;

      star.add(Star(Random().nextInt(400).toDouble(),
          Random().nextInt(1000).toDouble(), color));
    }

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3750),
    )..addListener(() {
        _render();
      });

    animationX = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    animationX = Tween<double>(begin: -8, end: 8).animate(animationX);

    animationY = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    animationY = Tween<double>(begin: -8, end: 8).animate(animationY);

    animationX.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  _render() {
    setState(() {
      cloudy.forEach((cloud) {
        cloud.dx = animationX.value;
        cloud.dy = animationY.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: CloudyPainter(cloudy, star),
      ),
      decoration: BoxDecoration(color: Color(0xFF041322)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

class CloudyPainter extends CustomPainter {
  List cloudy;

  List<Star> star;

  CloudyPainter(this.cloudy, this.star);

  Paint darkCloudPaint = new Paint()
    ..style = PaintingStyle.fill
    ..color = Color(0x4D24537D);

  Paint cloudPaint = new Paint()
    ..style = PaintingStyle.fill
    ..color = Color(0x622A5181);

  Paint lightCloudPaint = new Paint()
    ..style = PaintingStyle.fill
    ..color = Color(0x8A396D8B);

  Color c = Colors.white54;

  // 高清图再校准一下颜色
  Paint sunPaint = new Paint()
    ..style = PaintingStyle.fill
    ..color = Color(0xFFF9FFBD);

  Paint starPaint = new Paint()..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    canvas.drawCircle(
        Offset(width - 60 - cloudy.elementAt(0).x, 120 + cloudy.elementAt(0).y),
        100,
        darkCloudPaint);

    canvas.drawCircle(
        Offset(width / 2 - cloudy.elementAt(1).x, 20 - cloudy.elementAt(1).y),
        170,
        darkCloudPaint);

    canvas.drawCircle(Offset(width / 5 * 3, 140), 50, sunPaint);

    canvas.drawCircle(
        Offset(width / 5 * 3.6 + cloudy.elementAt(2).x,
            -20 - cloudy.elementAt(2).y),
        170,
        cloudPaint);

    canvas.drawCircle(
        Offset(width / 5 * 1.5 + cloudy.elementAt(6).x,
            -40 - cloudy.elementAt(6).y),
        210,
        cloudPaint);

    canvas.drawCircle(
        Offset(width / 5 * 3.6 - 10 + cloudy.elementAt(3).x,
            -50 + cloudy.elementAt(3).y),
        170,
        lightCloudPaint);

    canvas.drawCircle(
        Offset(10 + cloudy.elementAt(4).x, -30 + cloudy.elementAt(4).y),
        180,
        darkCloudPaint);

    canvas.drawCircle(
        Offset(35 - cloudy.elementAt(5).x, -110 + cloudy.elementAt(5).y),
        160,
        lightCloudPaint);

    for (var value in star) {
      starPaint.color = value.color;
      canvas.drawCircle(Offset(value.x, value.y), 1, starPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
