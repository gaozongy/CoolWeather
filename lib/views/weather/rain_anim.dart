import 'dart:math';

import 'package:flutter/material.dart';

import 'base_weather_state.dart';
import 'raindrop.dart';

class RainAnim extends StatefulWidget {
  RainAnim({Key key}) : super(key: key);

  @override
  RainAnimState createState() => RainAnimState();
}

class RainAnimState extends BaseAnimState<RainAnim> {
  AnimationController controller;

  var _area = Rect.fromLTRB(0, 0, 420, 700);

  var _balls = <Raindrop>[];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity() //生成一个单位矩阵
          ..setEntry(3, 2, 0.001) // 透视
          ..rotateX(0.6), // changed
        child: CustomPaint(
          size: Size(double.infinity, double.infinity),
          painter: RainPainter(_balls, _area, maskAlpha),
        ),
      ),
      decoration: BoxDecoration(color: Color.fromARGB(255, 16, 109, 153)),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(days: 1),
    )..addListener(() {
        _render();
      });

    createBall();

    controller.forward();
  }

  void createBall() {
    if (_balls.length > 60) {
      return;
    }

    double vY;
    double length = Random().nextInt(50).toDouble() + 15;
    double width;

    Color color;
    if (length < 30) {
      width = 1.15;
      color = randomColor(Color(0x2DE1F5FE));
      vY = 8;
    } else if (length < 35) {
      width = 1.2;
      color = randomColor(Color(0x4BE1F5FE));
      vY = 9;
    } else if (length < 40) {
      width = 1.35;
      color = randomColor(Color(0x69B3E5FC));
      vY = 10;
    } else if (length < 45) {
      width = 1.4;
      color = randomColor(Color(0x8781D4FA));
      vY = 11;
    } else if (length < 50) {
      width = 1.55;
      color = randomColor(Color(0xA581D4FA));
      vY = 12;
    } else if (length < 55) {
      width = 1.7;
      color = randomColor(Color(0xC34FC3F7));
      //       color = Color(0x87);
      //      vY = 9;
      //    } else if (length < 35) {
      //      color = Color(0xA5);
      //      vY = 10;
      //    } else if (length < 40) {
      //      color = Color(0xC3);
      vY = 16;
    } else if (length < 62) {
      width = 1.85;
      Color defaultColor = Color(0xE14FC3F7);
      color = randomColor(defaultColor);
      vY = 18;
      if (color.value != defaultColor.value && Random().nextInt(3) == 1) {
        width = 5;
      }
    } else {
      width = 2;
      Color defaultColor = Color(0xFF29B6F6);
      color = randomColor(defaultColor);
      vY = 24;
      if (color.value != defaultColor.value && Random().nextInt(3) == 1) {
        width = 5;
      }
    }

    _balls.add(Raindrop(
        color: color,
        x: _randPosition(),
        y: 0,
        width: width,
        vY: vY,
        length: length));
  }

  Color randomColor(Color defaultColor) {
    Color color;
    int num = Random().nextInt(20);
    if (num <= 3) {
      color = Color.fromARGB(defaultColor.alpha, 237, 255, 255);
    } else if (num <= 5) {
      color = Color.fromARGB(defaultColor.alpha, 159, 189, 103);
    } else {
      color = defaultColor;
    }
    return color;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  _render() {
    createBall();

    setState(() {
      _balls.forEach((ball) {
        updateBall(ball);
      });
    });
  }

  void updateBall(Raindrop _ball) {
    _ball.y += _ball.vY;

    // 限定下边界
    if (_ball.y > _area.bottom) {
      _ball.x = _randPosition();
      _ball.y = 0;
    }
  }

  double _randPosition([int seed]) {
    Random random;
    if (seed != null) {
      random = new Random(seed);
    } else {
      random = new Random();
    }

    return random.nextInt(410).toDouble();
  }
}
