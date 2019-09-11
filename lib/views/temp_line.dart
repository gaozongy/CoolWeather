import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// 气温折线图
class TempLineWidget extends StatelessWidget {
  final List<Temp> dots;

  TempLineWidget(this.dots);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(200, 100), painter: TempLinePainter(dots));
  }
}

Paint linePaint = new Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.white60
  ..strokeWidth = 1.0;

Paint dotPaint = new Paint()
  ..style = PaintingStyle.fill
  ..color = Colors.white70;

Paint bgPaint = new Paint()
  ..style = PaintingStyle.fill
  ..color = Colors.white12;
Path path = new Path();

class TempLinePainter extends CustomPainter {
  List<Temp> tempList;

  TempLinePainter(this.tempList);

  int margin = 20;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0, size.height / 2);

    double total = 0;
    tempList.forEach((temp) {
      total += (temp.top + temp.bot);
    });
    double average = total / (tempList.length * 2);

    List<Temp> drawList = List();

    tempList.forEach((temp) {
      drawList.add(Temp(-(temp.top - average) * 5, -(temp.bot - average) * 5));
    });

    double width = size.width / 6;

    // 画线
    drawLine(drawList, width, canvas, linePaint);

    // 画点和文字
    drawDotText(drawList, width, canvas, dotPaint);

    // 画背景颜色
    drawBg(drawList, width, size, canvas, bgPaint);
  }

  void drawLine(List<Temp> dots, double width, Canvas canvas, Paint linePaint) {
    for (int i = 0; i < dots.length - 1; i++) {
      double x = width * i + width / 2;

      if (i == 0) {
        canvas.drawLine(Offset(0, dots.elementAt(i).top),
            Offset(x, dots.elementAt(i).top), linePaint);

        canvas.drawLine(Offset(0, dots.elementAt(i).bot + margin),
            Offset(x, dots.elementAt(i).bot + margin), linePaint);
      } else if (i == dots.length - 2) {
        canvas.drawLine(
            Offset(x + width, dots.elementAt(i + 1).top),
            Offset(x + width + width / 2, dots.elementAt(i + 1).top),
            linePaint);

        canvas.drawLine(
            Offset(x + width, dots.elementAt(i + 1).bot + margin),
            Offset(x + width + width / 2, dots.elementAt(i + 1).bot + margin),
            linePaint);
      }

      canvas.drawLine(Offset(x, dots.elementAt(i).top),
          Offset(x + width, dots.elementAt(i + 1).top), linePaint);

      canvas.drawLine(Offset(x, dots.elementAt(i).bot + margin),
          Offset(x + width, dots.elementAt(i + 1).bot + margin), linePaint);
    }
  }

  void drawDotText(
      List<Temp> dots, double width, Canvas canvas, Paint dotPaint) {
    for (int i = 0; i < dots.length; i++) {
      double x = width * i + width / 2;

      // 画点
      canvas.drawCircle(Offset(x, dots.elementAt(i).top), 2, dotPaint);
      canvas.drawCircle(Offset(x, dots.elementAt(i).bot + margin), 2, dotPaint);

      // 画文字
      ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
          textAlign: TextAlign.left,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          fontSize: 12));
      pb.pushStyle(ui.TextStyle(color: Colors.white70));

      pb.addText('${tempList.elementAt(i).top.toInt()}' + '°');
      ParagraphConstraints pc = ParagraphConstraints(width: 30);
      Paragraph paragraph = pb.build()..layout(pc);
      Offset offset = Offset(x, dots.elementAt(i).top - 20);
      canvas.drawParagraph(paragraph, offset);

      ParagraphBuilder pb2 = ParagraphBuilder(ParagraphStyle(
          textAlign: TextAlign.left,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          fontSize: 12));
      pb2.pushStyle(ui.TextStyle(color: Colors.white70));

      pb2.addText('${tempList.elementAt(i).bot.toInt()}' + '°');
      ParagraphConstraints pc2 = ParagraphConstraints(width: 30);
      Paragraph paragraph2 = pb2.build()..layout(pc2);
      Offset offset2 = Offset(x, dots.elementAt(i).bot + margin + 5);

      canvas.drawParagraph(paragraph2, offset2);
    }
  }

  void drawBg(
      List<Temp> dots, double width, Size size, Canvas canvas, Paint bgPaint) {
    path.moveTo(0, dots.elementAt(0).top);
    for (int i = 0; i < dots.length; i++) {
      double x = width * i + width / 2;
      path.lineTo(x, dots.elementAt(i).top);
    }

    path.lineTo(size.width, dots.elementAt(5).top);
    path.lineTo(size.width, dots.elementAt(5).bot + margin);

    for (int i = 0; i < dots.length; i++) {
      double x = width * (5 - i) + width / 2;
      path.lineTo(x, dots.elementAt(5 - i).bot + margin);
    }

    path.lineTo(0, dots.elementAt(0).bot + margin);
    path.close();
    canvas.drawPath(path, bgPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Temp {
  double top;

  double bot;

  Temp(this.top, this.bot);
}
