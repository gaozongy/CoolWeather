import 'dart:async';
import 'dart:math';

import 'package:coolweather/utils/screen_utils.dart';
import 'package:flutter/material.dart';

import 'base_weather_state.dart';

class SnowNightAnim extends StatefulWidget {
  SnowNightAnim({Key key}) : super(key: key);

  @override
  SnowNightAnimState createState() => SnowNightAnimState();
}

class SnowNightAnimState extends BaseAnimState<SnowNightAnim>
    with WidgetsBindingObserver {
  AnimationController controller;

  double screenWidth;

  double screenHeight;

  List<Snowflake> snowflakeList = [];

  Timer timer;

  bool resumed = true;

  @override
  Widget build(BuildContext context) {
    screenWidth = ScreenUtils.getScreenWidth(context);
    screenHeight = ScreenUtils.getScreenHeight(context);

    return Container(
        child: CustomPaint(
          size: Size(double.infinity, double.infinity),
          painter: SnowNightPainter(snowflakeList, maskAlpha),
        ),
        decoration: BoxDecoration(
          color: Color(0xFF132F45),
        ));
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    createRaindropTimer();
    initController();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        resumed = true;
        break;
      case AppLifecycleState.inactive:
        resumed = false;
        break;
      case AppLifecycleState.paused:
        resumed = false;
        break;
      case AppLifecycleState.detached:
        resumed = false;
        break;
    }
  }

  void createRaindropTimer() {
    Duration duration = Duration(milliseconds: 100);
    timer = Timer.periodic(duration, (timer) {
      if (Random().nextDouble() >= 0.5 && resumed) {
        createRaindrop();
      }
    });
  }

  void initController() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(days: 1),
    )..addListener(() {
        snowflakeList.forEach((snowflake) {
          setState(() {
            updateBall(snowflake);
          });
        });
      });

    controller.forward();
  }

  void createRaindrop() {
    if (snowflakeList.length > 150) {
      timer.cancel();
      return;
    }

    double vX;
    double vY;
    double radius;
    Color color;

    double randomVx = Random().nextDouble() * 1.6;
    vX = randomVx < 0.8 ? randomVx : 0.8 - randomVx;

    double random = Random().nextDouble() * 4.6;
    if (random < 0.9) {
      vY = 1.8;
      radius = 2;
      color = randomColor(Color(0xFF264562));
    } else if (random < 1.8) {
      vY = 1.9;
      radius = 2.5;
      color = randomColor(Color(0xFF305371));

      if (Random().nextInt(3) == 0) {
        randomVx = Random().nextDouble() * 4;
        vX = randomVx < 2 ? randomVx : 2 - randomVx;
        vY = 5;
      }
    } else if (random < 2.6) {
      vY = 2.0;
      radius = 3;
      color = randomColor(Color(0xFF375E7F));

      if (Random().nextInt(3) == 0) {
        randomVx = Random().nextDouble() * 4;
        vX = randomVx < 2 ? randomVx : 2 - randomVx;
        vY = 6;
      }
    } else if (random < 3.4) {
      vY = 2.1;
      radius = 3.5;
      color = randomColor(Color(0xFF608BB4));

      if (Random().nextInt(4) == 0) {
        randomVx = Random().nextDouble() * 4;
        vX = randomVx < 2 ? randomVx : 2 - randomVx;
        vY = 6;
      }
    } else if (random < 4.2) {
      vY = 2.2;
      radius = 4;
      color = randomColor(Color(0xFF648FB7));

      if (Random().nextInt(5) == 0) {
        randomVx = Random().nextDouble() * 6;
        vX = randomVx < 3 ? randomVx : 3 - randomVx;
        vY = 6;
      }
    } else if (random < 4.4) {
      vY = 2.3;
      radius = (Random().nextInt(2) + 3).toDouble();
      color = randomColor(Color(0xFF729DC6));

      if (Random().nextInt(6) == 0) {
        randomVx = Random().nextDouble() * 6;
        vX = randomVx < 3 ? randomVx : 3 - randomVx;
        vY = 6;
      }
    } else if (random < 4.5) {
      vY = 2.4;
      radius = (Random().nextInt(5) + 5).toDouble();
      Color defaultColor = Color(0xFF81AAD4);
      color = randomColor(defaultColor);
    } else {
      vY = 2.5;
      radius = (Random().nextInt(5) + 10).toDouble();
      Color defaultColor = Color(0xFF81AAD4);
      color = randomColor(defaultColor);
    }

    snowflakeList.add(Snowflake(_randPosition(), 0, radius, vX, vY,
        Random().nextDouble() / 20, color, Random().nextDouble()));
  }

  Color randomColor(Color defaultColor) {
    Color color;
    double num = Random().nextDouble();
    if (num <= 0.05) {
      color = Color.fromARGB(defaultColor.alpha, 89, 182, 161);
    } else {
      color = defaultColor;
    }
    return color;
  }

  void updateBall(Snowflake snowflake) {
    snowflake.x += snowflake.vX;
    snowflake.y += snowflake.vY;

    if (snowflake.isHexagon && snowflake.y > 200) {
      snowflake.radius -= snowflake.vRadius;
    }

    // 限定下边界
    if (snowflake.y > screenHeight) {
      snowflake.x = _randPosition();
      snowflake.y = 0;
      snowflake.radius = snowflake.oldRadius;
    }

    if (snowflake.vY == 2.3 && snowflake.y > 200) {
      snowflake.radius -= snowflake.vRadius;
    }
  }

  double _randPosition() {
    return Random().nextDouble() * screenWidth.toInt();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }
}

class SnowNightPainter extends CustomPainter {
  List<Snowflake> snowflakeList;

  double maskAlpha;

  Paint mPaint = new Paint()..style = PaintingStyle.fill;

  SnowNightPainter(this.snowflakeList, this.maskAlpha);

  @override
  void paint(Canvas canvas, Size size) {
    snowflakeList.forEach((snowflake) {
      mPaint.color = Color.fromARGB((snowflake.color.alpha * maskAlpha).toInt(),
          snowflake.color.red, snowflake.color.green, snowflake.color.blue);
      _drawSnowflake(canvas, snowflake);
    });
  }

  _drawSnowflake(Canvas canvas, Snowflake snowflake) {
    if (snowflake.isHexagon) {
      num radians = pi / 6;
      Path path = Path();

      List<double> point0 = rotatePoint(snowflake.x, snowflake.y, snowflake.x,
          snowflake.y - snowflake.radius, snowflake.rotateRadians);
      path.moveTo(point0.elementAt(0), point0.elementAt(1));

      List<double> point1 = rotatePoint(
          snowflake.x,
          snowflake.y,
          snowflake.x + cos(radians) * snowflake.radius,
          snowflake.y - sin(radians) * snowflake.radius,
          snowflake.rotateRadians);
      path.lineTo(point1.elementAt(0), point1.elementAt(1));

      List<double> point2 = rotatePoint(
          snowflake.x,
          snowflake.y,
          snowflake.x + cos(radians) * snowflake.radius,
          snowflake.y + sin(radians) * snowflake.radius,
          snowflake.rotateRadians);
      path.lineTo(point2.elementAt(0), point2.elementAt(1));

      List<double> point3 = rotatePoint(snowflake.x, snowflake.y, snowflake.x,
          snowflake.y + snowflake.radius, snowflake.rotateRadians);
      path.lineTo(point3.elementAt(0), point3.elementAt(1));

      List<double> point4 = rotatePoint(
          snowflake.x,
          snowflake.y,
          snowflake.x - cos(radians) * snowflake.radius,
          snowflake.y + sin(radians) * snowflake.radius,
          snowflake.rotateRadians);
      path.lineTo(point4.elementAt(0), point4.elementAt(1));

      List<double> point5 = rotatePoint(
          snowflake.x,
          snowflake.y,
          snowflake.x - cos(radians) * snowflake.radius,
          snowflake.y - sin(radians) * snowflake.radius,
          snowflake.rotateRadians);
      path.lineTo(point5.elementAt(0), point5.elementAt(1));

      path.close();
      canvas.drawPath(path, mPaint);
    } else {
      canvas.drawCircle(
          Offset(snowflake.x, snowflake.y), snowflake.radius, mPaint);
    }
  }

  /// 计算任意点(x1,y1)，绕点(x0,y0)逆时针旋转radians弧度后的新坐标(x2,y2)
  List<double> rotatePoint(
      double x0, double y0, double x1, double y1, double radians) {
    double x2 = (x1 - x0) * cos(radians) - (y1 - y0) * sin(radians) + x0;
    double y2 = (x1 - x0) * sin(radians) + (y1 - y0) * cos(radians) + y0;
    return [x2, y2];
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Snowflake {
  double x;
  double y;
  double radius;
  double oldRadius;
  double vX;
  double vY;
  double vRadius;
  Color color;
  bool isHexagon;
  double rotateRadians;

  Snowflake(this.x, this.y, this.radius, this.vX, this.vY, this.vRadius,
      this.color, this.rotateRadians) {
    this.oldRadius = radius;
    this.isHexagon = oldRadius >= 5;
  }
}
