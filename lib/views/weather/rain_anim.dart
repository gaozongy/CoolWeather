import 'dart:math';

import 'package:flutter/material.dart';

import 'base_weather_state.dart';

class RainAnim extends StatefulWidget {
  final bool isDay;

  RainAnim(this.isDay, {Key key}) : super(key: key);

  @override
  RainAnimState createState() => RainAnimState();
}

class RainAnimState extends BaseAnimState<RainAnim> {
  AnimationController controller;

  var _area = Rect.fromLTRB(0, 0, 420, 700);

  List<Raindrop> raindropList = [];

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
          painter: RainPainter(raindropList, _area, maskAlpha, widget.isDay),
        ),
      ),
      decoration: BoxDecoration(
          color: widget.isDay
              ? Color.fromARGB(255, 16, 109, 153)
              : Color.fromARGB(255, 0, 34, 68)),
    );
  }

  @override
  void initState() {
    super.initState();
    initController();
  }

  void initController() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(days: 1),
    )..addListener(() {
        createRaindrop();
        raindropList.forEach((ball) {
          setState(() {
            updateBall(ball);
          });
        });
      });

    controller.forward();
  }

  void createRaindrop() {
    if (raindropList.length > 60) {
      return;
    }

    double vY;
    double length = Random().nextInt(50).toDouble() + 15;
    double width;

    Color color;
    if (length < 30) {
      width = 0.8;
      color = randomColor(Color(0x2DE1F5FE));
      vY = 8;
    } else if (length < 35) {
      width = 0.9;
      color = randomColor(Color(0x4BE1F5FE));
      vY = 9;
    } else if (length < 40) {
      width = 1.0;
      color = randomColor(Color(0x69B3E5FC));
      vY = 10;
    } else if (length < 45) {
      width = 1.1;
      color = randomColor(Color(0x8781D4FA));
      vY = 11;
    } else if (length < 50) {
      width = 1.2;
      color = randomColor(Color(0xA581D4FA));
      vY = 12;
    } else if (length < 55) {
      width = 1.3;
      color = randomColor(Color(0xC34FC3F7));
      vY = 16;
    } else if (length < 62) {
      width = 1.4;
      Color defaultColor = Color(0xE14FC3F7);
      color = randomColor(defaultColor);
      vY = 18;
      if (color.value != defaultColor.value && Random().nextInt(5) == 1) {
        width = 5;
      }
    } else {
      width = 1.5;
      Color defaultColor = Color(0xFF29B6F6);
      color = randomColor(defaultColor);
      vY = 24;
      if (color.value != defaultColor.value && Random().nextInt(5) == 1) {
        width = 6;
      }
    }

    raindropList.add(Raindrop(
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

  void updateBall(Raindrop _ball) {
    _ball.y += _ball.vY;

    // 限定下边界
    if (_ball.y > _area.bottom) {
      _ball.x = _randPosition();
      _ball.y = 0;
    }
  }

  double _randPosition() {
    return new Random().nextInt(410).toDouble();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

class RainPainter extends CustomPainter {
  List<Raindrop> raindropList;

  Rect area;

  double maskAlpha;

  bool isDay;

  Paint mPaint = new Paint();

  RainPainter(this.raindropList, this.area, this.maskAlpha, this.isDay);

  @override
  void paint(Canvas canvas, Size size) {
    Paint bgPaint = new Paint()
      ..color = isDay
          ? Color.fromARGB(255, 16, 109, 153)
          : Color.fromARGB(255, 0, 34, 68);

    canvas.drawRect(area, bgPaint);

    raindropList.forEach((ball) {
      mPaint.color = Color.fromARGB((ball.color.alpha * maskAlpha).toInt(),
          ball.color.red, ball.color.green, ball.color.blue);
      mPaint.strokeWidth = ball.width;
      _drawBall(canvas, ball);
    });
  }

  _drawBall(Canvas canvas, Raindrop ball) {
    canvas.drawLine(
        Offset(ball.x, ball.y), Offset(ball.x, ball.y + ball.length), mPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Raindrop {
  double vY;
  double x;
  double y;
  double width;
  Color color;
  double length;

  Raindrop(
      {this.vY = 0,
      this.x = 0,
      this.y = 0,
      this.width = 0,
      this.color,
      this.length});
}
