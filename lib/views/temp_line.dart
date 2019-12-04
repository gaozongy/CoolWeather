import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 气温折线图
class TempLine extends StatelessWidget {
  final double width;
  final List<Temp> tempList;

  TempLine(this.width, this.tempList);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        size: Size(width / 6 * tempList.length, 140),
        painter: TemperatureLinePainter(tempList));
  }
}

class TemperatureLinePainter extends CustomPainter {
  List<Temp> tempList;

  TemperatureLinePainter(this.tempList);

  int margin = 0;

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    canvas.translate(0, height / 2);

    Paint maxLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white70
      ..strokeWidth = 1;

    Paint minLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white38
      ..strokeWidth = 1;

    Paint dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white30,
        Colors.white10,
      ],
    );

    Rect arcRect = Rect.fromLTRB(0, 0, 0, 140);

    Paint bgPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(arcRect);

    double maxTemp = -double.infinity;
    double minTemp = double.infinity;
    tempList.forEach((temp) {
      if (temp.max > maxTemp) {
        maxTemp = temp.max;
      }
      if (temp.min < minTemp) {
        minTemp = temp.min;
      }
    });
    double centerLine = (maxTemp + minTemp) / 2;
    double cell = 140 / (maxTemp - minTemp) * 4 / 5;

    List<Temp> drawList = List();
    tempList.forEach((temp) {
      drawList.add(
          Temp((centerLine - temp.max) * cell, (centerLine - temp.min) * cell));
    });

    double distance = width / tempList.length;

    // 画线
    drawLine(drawList, distance, canvas, maxLinePaint, minLinePaint);

    // 画点和文字
    drawDotText(drawList, distance, canvas, dotPaint);

    // 画背景颜色
    drawBg(drawList, distance, width, canvas, bgPaint);
  }

  void drawLine(List<Temp> dots, double distance, Canvas canvas,
      Paint maxLinePaint, Paint minLinePaint) {
    for (int i = 0; i < dots.length - 1; i++) {
      double x = distance * i + distance / 2;

      canvas.drawLine(Offset(x, dots.elementAt(i).max),
          Offset(x + distance, dots.elementAt(i + 1).max), maxLinePaint);

      canvas.drawLine(
          Offset(x, dots.elementAt(i).min + margin),
          Offset(x + distance, dots.elementAt(i + 1).min + margin),
          minLinePaint);

      if (i == 0) {
        canvas.drawLine(Offset(0, dots.elementAt(i).max),
            Offset(x, dots.elementAt(i).max), maxLinePaint);

        canvas.drawLine(Offset(0, dots.elementAt(i).min + margin),
            Offset(x, dots.elementAt(i).min + margin), minLinePaint);
      } else if (i == dots.length - 2) {
        canvas.drawLine(
            Offset(x + distance, dots.elementAt(i + 1).max),
            Offset(x + distance + distance / 2, dots.elementAt(i + 1).max),
            maxLinePaint);

        canvas.drawLine(
            Offset(x + distance, dots.elementAt(i + 1).min + margin),
            Offset(x + distance + distance / 2,
                dots.elementAt(i + 1).min + margin),
            minLinePaint);
      }
    }
  }

  void drawDotText(
      List<Temp> dots, double distance, Canvas canvas, Paint dotPaint) {
    for (int i = 0; i < dots.length; i++) {
      double x = distance * i + distance / 2;

      // 画点
      canvas.drawCircle(Offset(x, dots.elementAt(i).max), 2, dotPaint);
      canvas.drawCircle(Offset(x, dots.elementAt(i).min + margin), 2, dotPaint);

      // 画文字
      TextPainter tpMax =
          getTextPainter('${(tempList.elementAt(i).max + 0.5).toInt()}' + '°');
      tpMax.paint(
          canvas, Offset(x - tpMax.width / 2, dots.elementAt(i).max - 15));

      TextPainter tpMin =
          getTextPainter('${(tempList.elementAt(i).min + 0.5).toInt()}' + '°');
      tpMin.paint(canvas,
          Offset(x - tpMin.width / 2, dots.elementAt(i).min + margin + 5));
    }
  }

  // 画文字
  TextPainter getTextPainter(String text) {
    return TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white54,
          fontSize: 10,
        ),
      ),
    )..layout();
  }

  void drawBg(List<Temp> dots, double distance, double width, Canvas canvas,
      Paint bgPaint) {
    Path path = new Path();
    path.moveTo(0, dots.elementAt(0).max);
    for (int i = 0; i < dots.length; i++) {
      double x = distance * i + distance / 2;
      path.lineTo(x, dots.elementAt(i).max);
    }

    path.lineTo(width, dots.elementAt(dots.length - 1).max);
    path.lineTo(width, dots.elementAt(dots.length - 1).min + margin);

    for (int i = 0; i < dots.length; i++) {
      double x = distance * (dots.length - 1 - i) + distance / 2;
      path.lineTo(x, dots.elementAt(dots.length - 1 - i).min + margin);
    }

    path.lineTo(0, dots.elementAt(0).min + margin);
    path.close();
    canvas.drawPath(path, bgPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Temp {
  double max;

  double min;

  Temp(this.max, this.min);
}
