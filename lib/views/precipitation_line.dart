import 'dart:ui';

import 'package:coolweather/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class PrecipitationLineWidget extends StatelessWidget {
  final List<double> precipitation2h;

  PrecipitationLineWidget(this.precipitation2h);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        size: Size(ScreenUtils.getScreenWidth(context), 140),
        painter: PrecipitationLinePainter(precipitation2h));
  }
}

Paint trendLinePaint = new Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.white
  ..strokeWidth = 1.4;

Paint bottomLinePaint = new Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.white60
  ..strokeWidth = 1;

class PrecipitationLinePainter extends CustomPainter {
  List<double> precipitation2h;

  PrecipitationLinePainter(this.precipitation2h);

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    canvas.translate(0, size.height / 1.5);
    double distance = size.width / precipitation2h.length;
    drawLine(precipitation2h, distance, canvas);

    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), bottomLinePaint);

    canvas.drawLine(Offset(0, -height / 4), Offset(size.width, -height / 4),
        bottomLinePaint);

    canvas.drawLine(Offset(0, -height / 4 * 2),
        Offset(size.width, -height / 4 * 2), bottomLinePaint);

    canvas.drawLine(Offset(0, -height / 4 * 3),
        Offset(size.width, -height / 4 * 3), bottomLinePaint);

    drawText(canvas, '现在', Offset(0, 0));
    drawText(canvas, '1小时', Offset(size.width / 2 - 20, 0));
    drawText(canvas, '2小时', Offset(size.width - 30, 0));
  }

  // 画文字
  void drawText(Canvas canvas, String text, Offset offset) {
    ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.left,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        fontSize: 12));
    pb.pushStyle(ui.TextStyle(color: Colors.white70));
    ParagraphConstraints pc = ParagraphConstraints(width: 50);
    pb.addText(text);
    Paragraph paragraph = pb.build()..layout(pc);
    canvas.drawParagraph(paragraph, offset);
  }

  void drawLine(List<double> precipitation2h, double distance, Canvas canvas) {
    for (int i = 0; i < precipitation2h.length - 1; i++) {
      double x = distance * i + distance / 2;

      canvas.drawLine(
          Offset(x, -precipitation2h.elementAt(i) * 300),
          Offset(x + distance, -precipitation2h.elementAt(i + 1) * 300),
          trendLinePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
