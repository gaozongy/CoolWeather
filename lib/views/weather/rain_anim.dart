import 'dart:math';

import 'package:flutter/material.dart';

import 'raindrop.dart';

class RainAnim extends StatefulWidget {

  final double maskAlpha;

  RainAnim(this.maskAlpha);

  @override
  _RainAnimState createState() => _RainAnimState();
}

class _RainAnimState extends State<RainAnim> with TickerProviderStateMixin {

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
          painter: RainPainter(_balls, _area, widget.maskAlpha),
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
    if (_balls.length > 80) {
      return;
    }

    double vY;
    double length = Random().nextInt(40).toDouble() + 10;
    double width = Random().nextInt(3).toDouble() + 1;

    // 5 5 5 5 5 5 5 5
    Color color;
    if (length < 15) {
      if (width > 2) {
        width = 2;
      }
      color = Color(0x2DE1F5FE);
      vY = 6;
    } else if (length < 25) {
      if (width > 2) {
        width = 2;
      }
      color = Color(0x4BE1F5FE);
      vY = 7;
    } else if (length < 25) {
      if (width > 2) {
        width = 2;
      }
      color = Color(0x69B3E5FC);
      vY = 8;
    } else if (length < 30) {
      if (width > 2) {
        width = 2;
      }
      color = Color(0x8781D4FA);
      vY = 9;
    } else if (length < 35) {
      color = Color(0xA581D4FA);
      vY = 10;
    } else if (length < 40) {
      color = Color(0xC34FC3F7);
      vY = 11;

      int num3 = Random().nextInt(5);
      if (num3 == 1) {
        width = width + 1;
      }
    } else if (length < 45) {
      color = Color(0xE14FC3F7);
      if (width >= 2) {
        int num = Random().nextInt(5);
        if (num <= 1) {
          color = Color(0xE1EDFFFF);
        } else if (num == 2) {
          color = Color(0xE19FBD67);
        }
      }

      int num2 = Random().nextInt(3);
      if (num2 == 1) {
        length = length + 20;
      }
      int num3 = Random().nextInt(5);
      if (num3 == 1) {
        width = width + 1;
      }
      vY = 12;
    } else {
      color = Color(0xFF29B6F6);
      if (width >= 2) {
        int num = Random().nextInt(5);
        if (num <= 1) {
          color = Color(0xFFEDFFFF);
        } else if (num == 2) {
          color = Color(0xFF9FBD67);
        }
      }
      int num2 = Random().nextInt(3);
      if (num2 == 1) {
        length = length + 30;
      }
      int num3 = Random().nextInt(5);
      if (num3 == 1) {
        width = width + 2;
      }
      vY = 14;
    }

    _balls.add(Raindrop(
        color: color,
        x: _randPosition(),
        y: 0,
        width: width,
        vY: vY,
        length: length));
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
