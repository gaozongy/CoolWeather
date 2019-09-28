import 'package:coolweather/bean/daily.dart';
import 'package:flutter/material.dart';

/// 日出日落
class SunriseSunsetWidget extends StatelessWidget {
  final Astro astro;

  SunriseSunsetWidget(this.astro);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(0, 80), painter: SunriseSunsetPainter(astro));
  }
}

Paint timeLinePaint = new Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.white38
  ..strokeWidth = 1.5;

Paint dotPaint = new Paint()
  ..style = PaintingStyle.fill
  ..color = Colors.white;

class SunriseSunsetPainter extends CustomPainter {
  final Astro astro;

  final padding = 2;

  SunriseSunsetPainter(this.astro);

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    canvas.drawLine(
        Offset(0, height / 2), Offset(width, height / 2), timeLinePaint);

    // ----------------------------    日出    ----------------------------
    DateTime sunriseTime =
        DateTime.parse(astro.date + ' ' + astro.sunrise.time);
    double sunriseOfDay = ((sunriseTime.hour * 60 + sunriseTime.minute) * 60 +
            sunriseTime.second) /
        (24 * 60 * 60);
    canvas.drawCircle(Offset(width * sunriseOfDay, height / 2), 2, dotPaint);
    TextPainter sunriseDescTp = getTextPainter('日出');
    sunriseDescTp.paint(
        canvas,
        Offset(width * sunriseOfDay - sunriseDescTp.width / 2,
            height / 2 - sunriseDescTp.height - padding));
    TextPainter sunriseTimeTp = getTextPainter('${astro.sunrise.time}');
    sunriseTimeTp.paint(canvas,
        Offset(width * sunriseOfDay - sunriseTimeTp.width / 2, height / 2 + padding));

    // ----------------------------    日落    ----------------------------
    DateTime sunsetTime = DateTime.parse(astro.date + ' ' + astro.sunset.time);
    double sunsetOfDay =
        ((sunsetTime.hour * 60 + sunsetTime.minute) * 60 + sunsetTime.second) /
            (24 * 60 * 60);
    canvas.drawCircle(Offset(width * sunsetOfDay, height / 2), 2, dotPaint);
    TextPainter sunsetDescTp = getTextPainter('日落');
    sunsetDescTp.paint(
        canvas,
        Offset(width * sunsetOfDay - sunsetDescTp.width / 2,
            height / 2 - sunsetDescTp.height - padding));
    TextPainter sunsetTp = getTextPainter('${astro.sunset.time}');
    sunsetTp.paint(
        canvas, Offset(width * sunsetOfDay - sunsetTp.width / 2, height / 2 + padding));

    // ----------------------------    当前    ----------------------------
    DateTime currentTime = DateTime.now();
    double currentOfDay = ((currentTime.hour * 60 + currentTime.minute) * 60 +
            currentTime.second) /
        (24 * 60 * 60);
    canvas.drawCircle(Offset(width * currentOfDay, height / 2), 2, dotPaint);
    TextPainter currentDescTp = getTextPainter('当前');
    currentDescTp.paint(
        canvas,
        Offset(width * currentOfDay - currentDescTp.width / 2,
            height / 2 - currentDescTp.height - padding));
    TextPainter currentTp =
        getTextPainter(' ${currentTime.hour}:${currentTime.minute}');
    currentTp.paint(
        canvas, Offset(width * currentOfDay - currentTp.width / 2, height / 2 + padding));
  }

  // 画文字
  TextPainter getTextPainter(String text) {
    return TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 10,
        ),
      ),
    )..layout();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
