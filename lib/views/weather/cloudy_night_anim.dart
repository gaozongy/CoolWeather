import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cloudy_paint.dart';

class Star {
  double x;
  double y;
  Color color;
  int alphaChange = 1;

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

  List<Cloud> cloudList = [];
  List<Star> starList = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 7; i++) {
      cloudList.add(Cloud(0, 0));
    }

    for (int i = 0; i < 45; i++) {
      int alpha = Random().nextInt(110);
      Color color = Color.fromARGB(alpha, 255, 255, 255);
      starList.add(Star(Random().nextInt(450).toDouble(),
          Random().nextInt(450).toDouble(), color));
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
      cloudList.forEach((cloud) {
        cloud.dx = animationX.value;
        cloud.dy = animationY.value;
      });

      starList.forEach((star) {
        int alpha = star.color.alpha;
        if (alpha <= 0) {
          star.alphaChange = 1;
        } else if (alpha >= 110) {
          star.alphaChange = -1;
        }
        alpha += star.alphaChange;
        star.color = Color.fromARGB(alpha, 255, 255, 255);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: CloudyPainter(cloudList, starList),
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
  List<Cloud> cloudList;

  List<Star> starList;

  CloudyPainter(this.cloudList, this.starList);

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
    ..color = Color(0xFFFBFFC0);

  Paint starPaint = new Paint()..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    for (var star in starList) {
      starPaint.color = star.color;
      canvas.drawCircle(Offset(star.x, star.y), 1.2, starPaint);
    }

    canvas.drawCircle(
        Offset(width - 60 - cloudList.elementAt(0).dx,
            120 + cloudList.elementAt(0).dy),
        100,
        darkCloudPaint);

    canvas.drawCircle(
        Offset(width / 2 - cloudList.elementAt(1).dx,
            20 - cloudList.elementAt(1).dy),
        170,
        darkCloudPaint);

    canvas.drawCircle(Offset(width / 5 * 3, 140), 50, sunPaint);

    canvas.drawCircle(
        Offset(width / 5 * 3.6 + cloudList.elementAt(2).dx,
            -20 - cloudList.elementAt(2).dy),
        170,
        cloudPaint);

    canvas.drawCircle(
        Offset(width / 5 * 1.5 + cloudList.elementAt(6).dx,
            -40 - cloudList.elementAt(6).dy),
        210,
        cloudPaint);

    canvas.drawCircle(
        Offset(width / 5 * 3.6 - 10 + cloudList.elementAt(3).dx,
            -50 + cloudList.elementAt(3).dy),
        170,
        lightCloudPaint);

    canvas.drawCircle(
        Offset(10 + cloudList.elementAt(4).dx, -30 + cloudList.elementAt(4).dy),
        180,
        darkCloudPaint);

    canvas.drawCircle(
        Offset(
            35 - cloudList.elementAt(5).dx, -110 + cloudList.elementAt(5).dy),
        160,
        lightCloudPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
