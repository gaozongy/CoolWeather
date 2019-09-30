import 'dart:ui';

import 'package:coolweather/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class PrecipitationLineWidget extends StatelessWidget {
  final List<double> precipitation2h;

  PrecipitationLineWidget(this.precipitation2h);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
          size: Size(ScreenUtils.getScreenWidth(context), 100),
          painter: PrecipitationLinePainter(precipitation2h)),
      decoration: BoxDecoration(color: Colors.transparent),
    );
  }
}

Paint bottomLinePaint = new Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.white38
  ..strokeWidth = 1;

Paint auxiliaryLinePaint = new Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.white12
  ..strokeWidth = 1;

Paint trendLinePaint = new Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.white60
  ..strokeWidth = 1.2;

class PrecipitationLinePainter extends CustomPainter {
  List<double> precipitation2h;

  PrecipitationLinePainter(this.precipitation2h);

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    canvas.translate(0, height);

    double distance = width / precipitation2h.length;
    drawLine(precipitation2h, distance, canvas);

    canvas.drawLine(Offset(0, 0), Offset(width, 0), bottomLinePaint);

    canvas.drawLine(Offset(0, -height / 3 * 1), Offset(width, -height / 3 * 1),
        auxiliaryLinePaint);

    canvas.drawLine(Offset(0, -height / 3 * 2), Offset(width, -height / 3 * 2),
        auxiliaryLinePaint);

    canvas.drawLine(Offset(0, -height / 3 * 3), Offset(width, -height / 3 * 3),
        auxiliaryLinePaint);

    TextPainter tpCurrent = getTextPainter('现在');
    tpCurrent.paint(canvas, Offset(0, 0));

    TextPainter tpOneHour = getTextPainter('1小时');
    tpOneHour.paint(canvas, Offset((width - tpOneHour.width) / 2, 0));

    TextPainter tpTwoHour = getTextPainter('2小时');
    tpTwoHour.paint(canvas, Offset(width - tpTwoHour.width, 0));
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

  // 画文字,无法计算绘制文字的实际宽高，暂时未使用，有时间研究下
  void drawText(Canvas canvas, String text, Offset offset) {
    ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.left,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        fontSize: 12));
    pb.pushStyle(ui.TextStyle(color: Colors.white70));
    ParagraphConstraints pc = ParagraphConstraints(width: 40);
    pb.addText(text);
    Paragraph paragraph = pb.build()..layout(pc);
    canvas.drawParagraph(paragraph, offset);
  }

  void drawLine(List<double> precipitation2h, double distance, Canvas canvas) {
    for (int i = 0; i < precipitation2h.length - 1; i++) {
      double x = distance * i + distance / 2;

      canvas.drawLine(
          Offset(x, -precipitation2h.elementAt(i) * 100),
          Offset(x + distance, -precipitation2h.elementAt(i + 1) * 100),
          trendLinePaint);

      if (i == 0) {
        canvas.drawLine(
            Offset(0, -precipitation2h.elementAt(0) * 100),
            Offset(distance / 2, -precipitation2h.elementAt(0) * 100),
            trendLinePaint);
      } else if (i == precipitation2h.length - 2) {
        canvas.drawLine(
            Offset(x + distance,
                -precipitation2h.elementAt(precipitation2h.length - 1) * 100),
            Offset(x + distance + distance / 2,
                -precipitation2h.elementAt(precipitation2h.length - 1) * 100),
            trendLinePaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
