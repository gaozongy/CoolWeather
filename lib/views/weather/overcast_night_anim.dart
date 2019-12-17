import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cloudy_paint.dart';

class OvercastNightAnim extends StatefulWidget {
  final double maskAlpha;

  OvercastNightAnim(this.maskAlpha);

  @override
  _OvercastNightAnimState createState() => _OvercastNightAnimState();
}

class _OvercastNightAnimState extends State<OvercastNightAnim>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animationX;
  Animation<double> animationY;

  List<Cloud> cloudList = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 7; i++) {
      cloudList.add(Cloud(0, 0));
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
      cloudList.forEach((cloud) {
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
          painter: OvercastPainter(cloudList, widget.maskAlpha)),
      decoration: BoxDecoration(color: Color(0xFF171E26)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

class OvercastPainter extends CustomPainter {
  List<Cloud> cloudList;

  double maskAlpha;

  Paint whiteCloudPaint = new Paint()..style = PaintingStyle.fill;

  Paint greyCloudPaint = new Paint()..style = PaintingStyle.fill;

  OvercastPainter(this.cloudList, this.maskAlpha);

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    whiteCloudPaint..color = Color.fromARGB((153 * maskAlpha).toInt(), 74,97,110);

    greyCloudPaint..color = Color.fromARGB((153 * maskAlpha).toInt(), 22,40,50);

    canvas.drawCircle(
        Offset(width - 60 - cloudList.elementAt(0).dx,
            110 + cloudList.elementAt(0).dy),
        100,
        greyCloudPaint);

    canvas.drawCircle(
        Offset(width / 2 - cloudList.elementAt(1).dx,
            20 - cloudList.elementAt(1).dy),
        170,
        greyCloudPaint);

    canvas.drawCircle(
        Offset(width / 5 * 3.6 + cloudList.elementAt(2).dx,
            -20 - cloudList.elementAt(2).dy),
        170,
        whiteCloudPaint);

    canvas.drawCircle(
        Offset(width / 5 * 3.6 - 10 + cloudList.elementAt(3).dx,
            -50 + cloudList.elementAt(3).dy),
        170,
        greyCloudPaint);

    canvas.drawCircle(
        Offset(width / 5 * 1.5 + cloudList.elementAt(6).dx,
            -40 - cloudList.elementAt(6).dy),
        210,
        whiteCloudPaint);

    canvas.drawCircle(
        Offset(10 + cloudList.elementAt(4).dx, -30 + cloudList.elementAt(4).dy),
        180,
        greyCloudPaint);

    canvas.drawCircle(
        Offset(
            35 - cloudList.elementAt(5).dx, -110 + cloudList.elementAt(5).dy),
        160,
        whiteCloudPaint);

    canvas.drawCircle(
        Offset(width / 5 * 4 - 10 + cloudList.elementAt(3).dx,
            -90 + cloudList.elementAt(3).dy),
        170,
        whiteCloudPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
