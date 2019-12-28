import 'dart:async';
import 'dart:math';

import 'package:coolweather/utils/screen_utils.dart';
import 'package:flutter/material.dart';

import 'base_weather_state.dart';

class HazeAnim extends StatefulWidget {
  final bool isDay;

  HazeAnim(this.isDay, {Key key}) : super(key: key);

  @override
  HazeAnimState createState() => HazeAnimState();
}

class HazeAnimState extends BaseAnimState<HazeAnim> {
  AnimationController controller;

  double screenWidth;

  double screenHeight;

  List<Dust> dustList = [];

  Timer timer;

  @override
  Widget build(BuildContext context) {
    screenWidth = ScreenUtils.getScreenWidth(context);
    screenHeight = ScreenUtils.getScreenHeight(context);

    return Container(
      child: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: RainPainter(dustList, maskAlpha, widget.isDay),
      ),
      decoration: BoxDecoration(
          color: widget.isDay ? Color(0xFF475D6A) : Color(0xFF272B2D)),
    );
  }

  @override
  void initState() {
    super.initState();

    createRaindropTimer();
    initController();
  }

  void createRaindropTimer() {
    Duration duration = Duration(milliseconds: 100);
    timer = Timer.periodic(duration, (timer) {
      createRaindrop();
    });
  }

  void initController() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(days: 1),
    )..addListener(() {
        dustList.forEach((dust) {
          setState(() {
            updateBall(dust);
          });
        });
      });

    controller.forward();
  }

  void createRaindrop() {
    if (dustList.length > 600) {
      timer.cancel();
      return;
    }

    double vX;
    double vY;
    double radius;
    Color color;

    double randomVx = Random().nextDouble() * 1;
    vX = randomVx < 0.5 ? randomVx : 0.5 - randomVx;

    double random = Random().nextDouble() * 4.6;
    if (random < 0.9) {
      vY = -0.6;
      radius = 0.6;
      color = widget.isDay ? Color(0x77F2BD5F) : Color(0x778B6C35);
    } else if (random < 1.8) {
      vY = -0.61;
      radius = 0.7;
      color = widget.isDay ? Color(0x88F2BD5F) : Color(0x888B6C35);
    } else if (random < 2.6) {
      vY = -0.62;
      radius = 0.8;
      color = widget.isDay ? Color(0x99F2BD5F) : Color(0x998B6C35);
    } else if (random < 3.4) {
      vY = -0.63;
      radius = 0.9;
      color = widget.isDay ? Color(0xAAF2BD5F) : Color(0xAA8B6C35);
    } else if (random < 4.2) {
      vY = -0.64;
      radius = 1.0;
      color = widget.isDay ? Color(0xBBF2BD5F) : Color(0xBB8B6C35);
    } else if (random < 4.4) {
      vY = -0.65;
      radius = 1.1;
      color = widget.isDay ? Color(0xCCF2BD5F) : Color(0xCC8B6C35);
    } else if (random < 4.5) {
      vY = -0.66;
      radius = 1.2;
      color = widget.isDay ? Color(0xDDF2BD5F) : Color(0xDD8B6C35);
    } else {
      vY = -0.67;
      radius = 1.3;
      color = widget.isDay ? Color(0xEEF2BD5F) : Color(0xEE8B6C35);
    }

    if (Random().nextInt(4) == 0) {
      randomVx = Random().nextDouble() * 2;
      vX = randomVx < 1 ? randomVx : 1 - randomVx;
      vY = -1.5;
    }

    dustList.add(Dust(
      _randomDouble(screenWidth),
      _randomDouble(screenHeight),
      radius,
      vX,
      vY,
      color,
    ));
  }

  void updateBall(Dust dust) {
    dust.x += dust.vX;
    dust.y += dust.vY;

    // 限定上边界
    if (dust.y < 0) {
      dust.x = _randomDouble(screenWidth);
      dust.y = screenHeight;
    }
  }

  double _randomDouble(double range) {
    return Random().nextDouble() * range;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    timer.cancel();
  }
}

class RainPainter extends CustomPainter {
  List<Dust> dustList;

  double maskAlpha;

  bool isDay;

  Paint mPaint = new Paint()..style = PaintingStyle.fill;

  RainPainter(this.dustList, this.maskAlpha, this.isDay);

  @override
  void paint(Canvas canvas, Size size) {
    dustList.forEach((snowflake) {
      mPaint.color = Color.fromARGB((snowflake.color.alpha * maskAlpha).toInt(),
          snowflake.color.red, snowflake.color.green, snowflake.color.blue);
      _drawDust(canvas, snowflake);
    });
  }

  _drawDust(Canvas canvas, Dust dust) {
    canvas.drawCircle(Offset(dust.x, dust.y), dust.radius, mPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Dust {
  double x;
  double y;
  double radius;
  double vX;
  double vY;
  Color color;

  Dust(this.x, this.y, this.radius, this.vX, this.vY, this.color);
}
