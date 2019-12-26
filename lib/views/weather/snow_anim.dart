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
    if (snowflakeList.length > 160) {
      return;
    }

    double vY = 0;
    double radius;
    double random = Random().nextDouble() * 6;

    Color color;
    if (random < 1) {
      vY = 1.6;
      radius = 2;
      color = randomColor(Color(0xFF264562));
    } else if (random < 2) {
      vY = 1.7;
      radius = 2.5;
      color = randomColor(Color(0xFF305371));
    } else if (random < 3) {
      vY = 1.8;
      radius = 3;
      color = randomColor(Color(0xFF375E7F));
    } else if (random < 4.5) {
      vY = 1.9;
      radius = 3.5;
      color = randomColor(Color(0xFF5983AB));
    } else if (random < 5.9) {
      vY = 2.0;
      radius = 4;
      color = randomColor(Color(0xFF608BB5));
    } else if (random < 6) {
      vY = 2.1;
      radius = 4.5;
      color = randomColor(Color(0xFF6B96C0));
    }
//    else if (random < 7) {
//      vY = 2.1;
//      radius = 5;
//      Color defaultColor = Color(0xE181ABD5);
//      color = randomColor(defaultColor);
//    } else {
//      vY = 2.2;
//      radius = 5.2;
//      Color defaultColor = Color(0xFF81ABD5);
//      color = randomColor(defaultColor);
//    }

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
    double num = Random().nextDouble();
    if (num <= 0.05) {
      color = Color.fromARGB(defaultColor.alpha, 86, 177, 160);
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
//    if (snowflake.radius >= 11.5) {
//      num radians = pi / 6;
//      Path path = Path();
//      path.moveTo(snowflake.x, snowflake.y - snowflake.radius);
//      path.lineTo(snowflake.x + cos(radians) * snowflake.radius,
//          snowflake.y - sin(radians) * snowflake.radius);
//      path.lineTo(snowflake.x + cos(radians) * snowflake.radius,
//          snowflake.y + sin(radians) * snowflake.radius);
//      path.lineTo(snowflake.x, snowflake.y + snowflake.radius);
//      path.lineTo(snowflake.x - cos(radians) * snowflake.radius,
//          snowflake.y + sin(radians) * snowflake.radius);
//      path.lineTo(snowflake.x - cos(radians) * snowflake.radius,
//          snowflake.y - sin(radians) * snowflake.radius);
//      path.close();
//      canvas.drawPath(path, mPaint);
//    } else {
    canvas.drawCircle(
        Offset(snowflake.x, snowflake.y), snowflake.radius, mPaint);
//    }
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
