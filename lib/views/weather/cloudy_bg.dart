import 'package:flutter/material.dart';

import 'cloudy_paint.dart';

class CloudyBg extends StatefulWidget {
  @override
  _CloudyBgState createState() => _CloudyBgState();
}

class _CloudyBgState extends State<CloudyBg> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animationX;
  Animation<double> animationY;

  List cloudy = <Cloud>[];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 7; i++) {
      cloudy.add(Cloud(0, 0));
    }

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..addListener(() {
        _render();
      });

    animationX = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    animationX = Tween<double>(begin: -5, end: 5).animate(animationX);

    animationY = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    animationY = Tween<double>(begin: -5, end: 5).animate(animationY);

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
        cloud.dy = animationY.value;
        cloud.dx = animationX.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: CloudyPainter(cloudy),
      ),
      decoration: BoxDecoration(color: Color(0xFF4B97D1)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
