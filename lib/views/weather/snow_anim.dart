import 'dart:math';

import 'package:flutter/material.dart';

import 'base_weather_state.dart';

class SnowAnim extends StatefulWidget {
  final bool isDay;

  SnowAnim(this.isDay, {Key key}) : super(key: key);

  @override
  SnowAnimState createState() => SnowAnimState();
}

class SnowAnimState extends BaseAnimState<SnowAnim> {
  AnimationController controller;

  var _area = Rect.fromLTRB(0, 0, 420, 700);

  List<Snowflake> snowflakeList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: RainPainter(snowflakeList, _area, maskAlpha, widget.isDay),
      ),
      decoration: BoxDecoration(
          color: widget.isDay
              ? Color.fromARGB(255, 16, 109, 153)
              : Color.fromARGB(255, 19, 47, 69)),
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
        snowflakeList.forEach((ball) {
          setState(() {
            updateBall(ball);
          });
        });
      });

    controller.forward();
  }

  void createRaindrop() {
    if (snowflakeList.length > 80) {
      return;
    }

    double vY;
    double radius = Random().nextInt(16).toDouble() + 4;

    Color color;
    if (radius < 6) {
      color = randomColor(Color(0x2DE1F5FE));
      vY = 2.5;
    } else if (radius < 8) {
      color = randomColor(Color(0x4BE1F5FE));
      vY = 2.75;
    } else if (radius < 10) {
      color = randomColor(Color(0x69B3E5FC));
      vY = 3;
    } else if (radius < 12) {
      color = randomColor(Color(0x8781D4FA));
      vY = 3.25;
    } else if (radius < 14) {
      color = randomColor(Color(0xA581D4FA));
      vY = 3.5;
    } else if (radius < 16) {
      color = randomColor(Color(0xC34FC3F7));
      vY = 3.75;
    } else if (radius < 18) {
      Color defaultColor = Color(0xE14FC3F7);
      color = randomColor(defaultColor);
      vY = 4;
    } else {
      Color defaultColor = Color(0xFF29B6F6);
      color = randomColor(defaultColor);
      vY = 4.25;
    }

    snowflakeList.add(Snowflake(
      color: color,
      x: _randPosition(),
      y: 0,
      radius: radius,
      vY: vY,
    ));
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

  void updateBall(Snowflake snowflake) {
    snowflake.y += snowflake.vY;

    // 限定下边界
    if (snowflake.y > _area.bottom) {
      snowflake.x = _randPosition();
      snowflake.y = 0;
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
  List<Snowflake> snowflakeList;

  Rect area;

  double maskAlpha;

  bool isDay;

  Paint mPaint = new Paint()..style = PaintingStyle.fill;

  RainPainter(this.snowflakeList, this.area, this.maskAlpha, this.isDay);

  @override
  void paint(Canvas canvas, Size size) {
    Paint bgPaint = new Paint()
      ..color = isDay
          ? Color.fromARGB(255, 16, 109, 153)
          : Color.fromARGB(255, 19, 47, 69);

    canvas.drawRect(area, bgPaint);

    snowflakeList.forEach((snowflake) {
      mPaint.color = Color.fromARGB((snowflake.color.alpha * maskAlpha).toInt(),
          snowflake.color.red, snowflake.color.green, snowflake.color.blue);
      _drawSnowflake(canvas, snowflake);
    });
  }

  _drawSnowflake(Canvas canvas, Snowflake snowflake) {
    if (snowflake.radius >= 16) {
      num radians = pi / 6;
      Path path = Path();
      path.moveTo(snowflake.x, snowflake.y - snowflake.radius);
      path.lineTo(snowflake.x + cos(radians) * snowflake.radius,
          snowflake.y - sin(radians) * snowflake.radius);
      path.lineTo(snowflake.x + cos(radians) * snowflake.radius,
          snowflake.y + sin(radians) * snowflake.radius);
      path.lineTo(snowflake.x, snowflake.y + snowflake.radius);
      path.lineTo(snowflake.x - cos(radians) * snowflake.radius,
          snowflake.y + sin(radians) * snowflake.radius);
      path.lineTo(snowflake.x - cos(radians) * snowflake.radius,
          snowflake.y - sin(radians) * snowflake.radius);
      path.close();
      canvas.drawPath(path, mPaint);
    } else {
      canvas.drawCircle(
          Offset(snowflake.x, snowflake.y), snowflake.radius, mPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Snowflake {
  double x;
  double y;
  double vY;

  double radius;
  Color color;

  Snowflake({this.x = 0, this.y = 0, this.radius = 0, this.vY = 0, this.color});
}
