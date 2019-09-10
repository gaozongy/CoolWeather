import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class TempLineWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: TempLinePainter());
  }
}

class TempLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width / 6;

    List<double> dots = new List();
    dots.add(100);
    dots.add(93);
    dots.add(80);
    dots.add(103);
    dots.add(103);
    dots.add(108);

    List<double> dots2 = new List();
    dots2.add(100);
    dots2.add(104);
    dots2.add(98);
    dots2.add(108);
    dots2.add(107);
    dots2.add(112);

    // 画线
    Paint linePaint = new Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white60
      ..strokeWidth = 1.0;

    // 画点
    Paint dotPaint = new Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white70;

    // 画背景颜色
    Paint bgPaint = new Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white10;
    Path path = new Path();

    for (int i = 0; i < dots.length - 1; i++) {
      double x = width * i + width / 2;

      if (i == 0) {
        canvas.drawLine(Offset(0, dots.elementAt(i)),
            Offset(x, dots.elementAt(i)), linePaint);

        canvas.drawLine(Offset(0, dots2.elementAt(i) + 50),
            Offset(x, dots2.elementAt(i) + 50), linePaint);
      } else if (i == dots.length - 2) {
        canvas.drawLine(Offset(x + width, dots.elementAt(i + 1)),
            Offset(x + width + width / 2, dots.elementAt(i + 1)), linePaint);

        canvas.drawLine(
            Offset(x + width, dots2.elementAt(i + 1) + 50),
            Offset(x + width + width / 2, dots2.elementAt(i + 1) + 50),
            linePaint);
      }

      canvas.drawLine(Offset(x, dots.elementAt(i)),
          Offset(x + width, dots.elementAt(i + 1)), linePaint);

      canvas.drawLine(Offset(x, dots2.elementAt(i) + 50),
          Offset(x + width, dots2.elementAt(i + 1) + 50), linePaint);
    }

    for (int i = 0; i < dots.length; i++) {
      double x = width * i + width / 2;

      // 画点
      canvas.drawCircle(
        Offset(x, dots.elementAt(i)),
        2,
        dotPaint,
      );

      canvas.drawCircle(
        Offset(x, dots2.elementAt(i) + 50),
        2,
        dotPaint,
      );

      // 画文字
      ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.left,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.normal,
        fontSize: 12,
      ));
      pb.pushStyle(ui.TextStyle(color: Colors.white70));

      pb.addText('${dots.elementAt(i) - 70}');
      ParagraphConstraints pc = ParagraphConstraints(width: 30);
      Paragraph paragraph = pb.build()..layout(pc);
      Offset offset = Offset(x - paragraph.width / 2, dots.elementAt(i) - 20);
      canvas.drawParagraph(paragraph, offset);

      Offset offset2 = Offset(x - paragraph.width / 2, dots2.elementAt(i) + 60);
      canvas.drawParagraph(paragraph, offset2);
    }

    path.moveTo(0, dots.elementAt(0));

    for (int i = 0; i < dots.length; i++) {
      double x = width * i + width / 2;

      path.lineTo(x, dots.elementAt(i));
    }

    path.lineTo(size.width, dots.elementAt(5));
    path.lineTo(size.width, dots2.elementAt(5) + 50);

    for (int i = 0; i < dots2.length; i++) {
      double x = width * (5 - i) + width / 2;

      path.lineTo(x, dots2.elementAt(5 - i) + 50);
    }

    path.lineTo(0, dots2.elementAt(0) + 50);
    path.close();
    canvas.drawPath(path, bgPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
