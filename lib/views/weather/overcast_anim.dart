import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base_weather_state.dart';
import 'cloudy_paint.dart';

class OvercastAnim extends StatefulWidget {

  OvercastAnim({Key key}) : super(key: key);

  @override
  _OvercastAnimState createState() => _OvercastAnimState();
}

class _OvercastAnimState extends BaseAnimState<OvercastAnim> {
  AnimationController controller;
  Animation<double> animationX;
  Animation<double> animationY;

  List<Cloud> cloudy = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 7; i++) {
      cloudy.add(Cloud(0, 0));
    }

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3750),
    )
      ..addListener(() {
        _render();
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
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
          size: Size(double.infinity, double.infinity),
          painter: OvercastPainter(cloudy, maskAlpha)),
      decoration: BoxDecoration(color: Color(0xFF93A4AE)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

class OvercastPainter extends CustomPainter {
  List<Cloud> cloudy;

  double maskAlpha;

  Paint whiteCloudPaint = new Paint()..style = PaintingStyle.fill;

  Paint greyCloudPaint = new Paint()..style = PaintingStyle.fill;

  OvercastPainter(this.cloudy, this.maskAlpha);

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    whiteCloudPaint
      ..color = Color.fromARGB((138 * maskAlpha).toInt(), 255, 255, 255);

    greyCloudPaint
      ..color = Color.fromARGB((179 * maskAlpha).toInt(), 130, 147, 158);

    canvas.drawCircle(
        Offset(
            width - 60 - cloudy.elementAt(0).dx, 110 + cloudy.elementAt(0).dy),
        100,
        greyCloudPaint);

    canvas.drawCircle(
        Offset(width / 2 - cloudy.elementAt(1).dx, 20 - cloudy.elementAt(1).dy),
        170,
        greyCloudPaint);

    canvas.drawCircle(
        Offset(width / 5 * 3.6 + cloudy.elementAt(2).dx,
            -20 - cloudy.elementAt(2).dy),
        170,
        whiteCloudPaint);

    canvas.drawCircle(
        Offset(width / 5 * 3.6 - 10 + cloudy.elementAt(3).dx,
            -50 + cloudy.elementAt(3).dy),
        170,
        greyCloudPaint);

    canvas.drawCircle(
        Offset(width / 5 * 1.5 + cloudy.elementAt(6).dx,
            -40 - cloudy.elementAt(6).dy),
        210,
        whiteCloudPaint);

    canvas.drawCircle(
        Offset(10 + cloudy.elementAt(4).dx, -30 + cloudy.elementAt(4).dy),
        180,
        greyCloudPaint);

    canvas.drawCircle(
        Offset(35 - cloudy.elementAt(5).dx, -110 + cloudy.elementAt(5).dy),
        160,
        whiteCloudPaint);

    canvas.drawCircle(
        Offset(width / 5 * 4 - 10 + cloudy.elementAt(3).dx,
            -90 + cloudy.elementAt(3).dy),
        170,
        whiteCloudPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
