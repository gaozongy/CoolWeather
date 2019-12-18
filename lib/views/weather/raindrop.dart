import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Raindrop {
  double vY;
  double x;
  double y;
  double width;
  Color color;
  double length;
  static int _count = 0;
  int id;

  Raindrop(
      {this.vY = 0,
      this.x = 0,
      this.y = 0,
      this.width = 0,
      this.color,
      this.length}) {
    _count++;
    this.id = _count * 2;
  }
}

class RainPainter extends CustomPainter {

  List<Raindrop> _balls;

  Rect _area;

  double maskAlpha;

  Paint mPaint = new Paint();

  Paint bgPaint = new Paint()..color = Color.fromARGB(255, 16, 109, 153);

  RainPainter(this._balls, this._area, this.maskAlpha);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(_area, bgPaint);

    _balls.forEach((ball) {
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
