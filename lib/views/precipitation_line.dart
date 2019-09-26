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

    precipitation2h = getData();

    canvas.translate(0, size.height);

    double distance = size.width / precipitation2h.length;
    drawLine(precipitation2h, distance, canvas);

    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), bottomLinePaint);

    canvas.drawLine(Offset(0, -height / 3 * 1),
        Offset(size.width, -height / 3 * 1), auxiliaryLinePaint);

    canvas.drawLine(Offset(0, -height / 3 * 2),
        Offset(size.width, -height / 3 * 2), auxiliaryLinePaint);

    canvas.drawLine(Offset(0, -height / 3 * 3),
        Offset(size.width, -height / 3 * 3), auxiliaryLinePaint);

    drawText(canvas, '现在', Offset(0, 0));
    drawText(canvas, '1小时', Offset(size.width / 2 - 20, 0));
    drawText(canvas, '2小时', Offset(size.width - 40, 0));

    canvas.drawCircle(Offset(width / 2, 0), 2, trendLinePaint);

    canvas.drawLine(Offset(width / 2 - 20, 0),
        Offset(width / 2 + 20, 0), trendLinePaint);
  }

  // 画文字
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

  List<double> getData() {
    return [
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0077,
      0.0389,
      0.0625,
      0.0762,
      0.0814,
      0.0804,
      0.0753,
      0.0686,
      0.0625,
      0.0588,
      0.0574,
      0.0577,
      0.0591,
      0.0609,
      0.0625,
      0.0635,
      0.0639,
      0.0638,
      0.0634,
      0.0629,
      0.0625,
      0.0622,
      0.0621,
      0.0622,
      0.0623,
      0.0624,
      0.0625,
      0.0626,
      0.0626,
      0.0626,
      0.0626,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625,
      0.0625
    ];
  }
}
