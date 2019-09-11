import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// 气温折线图
class TempLineWidget extends StatelessWidget {
  final List<Temp> tempList;

  TempLineWidget(this.tempList);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(0, 140),painter: TempLinePainter(tempList));
  }
}

Paint linePaint = new Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.white60
  ..strokeWidth = 1.4;

Paint line2Paint = new Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.white54
  ..strokeWidth = 1.4;

Paint dotPaint = new Paint()
  ..style = PaintingStyle.fill
  ..color = Colors.white;

Gradient gradient = new SweepGradient(
  startAngle: 90,
  endAngle: 180,
  colors: [
    Colors.red,
    Colors.white,
  ],
);

Rect arcRect = Rect.fromLTRB(0, 0, 100, 300);

Paint bgPaint = new Paint()
  ..style = PaintingStyle.fill
  ..strokeCap = StrokeCap.square
//  ..shader = gradient.createShader(arcRect)
  ..color = Colors.white12;

Path path = new Path();

class TempLinePainter extends CustomPainter {
  List<Temp> tempList;

  TempLinePainter(this.tempList);

  int margin = 0;

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
      drawList.add(Temp((average - temp.top) * 5, (average - temp.bot) * 5));
    });

    double distance = size.width / tempList.length;

    // 画线
    drawLine(drawList, distance, canvas, linePaint);

    // 画点和文字
    drawDotText(drawList, distance, canvas, dotPaint);

    // 画背景颜色
    drawBg(drawList, distance, size, canvas, bgPaint);
  }

  void drawLine(
      List<Temp> dots, double distance, Canvas canvas, Paint linePaint) {
    for (int i = 0; i < dots.length - 1; i++) {
      double x = distance * i + distance / 2;

      canvas.drawLine(Offset(x, dots.elementAt(i).top),
          Offset(x + distance, dots.elementAt(i + 1).top), linePaint);

      canvas.drawLine(Offset(x, dots.elementAt(i).bot + margin),
          Offset(x + distance, dots.elementAt(i + 1).bot + margin), line2Paint);

      if (i == 0) {
        canvas.drawLine(Offset(0, dots.elementAt(i).top),
            Offset(x, dots.elementAt(i).top), linePaint);

        canvas.drawLine(Offset(0, dots.elementAt(i).bot + margin),
            Offset(x, dots.elementAt(i).bot + margin), line2Paint);
      } else if (i == dots.length - 2) {
        canvas.drawLine(
            Offset(x + distance, dots.elementAt(i + 1).top),
            Offset(x + distance + distance / 2, dots.elementAt(i + 1).top),
            linePaint);

        canvas.drawLine(
            Offset(x + distance, dots.elementAt(i + 1).bot + margin),
            Offset(x + distance + distance / 2,
                dots.elementAt(i + 1).bot + margin),
            line2Paint);
      }
    }
  }

  void drawDotText(
      List<Temp> dots, double distance, Canvas canvas, Paint dotPaint) {
    for (int i = 0; i < dots.length; i++) {
      double x = distance * i + distance / 2;

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

      pb.addText('${tempList.elementAt(i).bot.toInt()}' + '°');
      Paragraph paragraph2 = pb.build()..layout(pc);
      Offset offset2 = Offset(x, dots.elementAt(i).bot + margin + 5);

      canvas.drawParagraph(paragraph2, offset2);
    }
  }

  void drawBg(List<Temp> dots, double distance, Size size, Canvas canvas,
      Paint bgPaint) {
    path.moveTo(0, dots.elementAt(0).top);
    for (int i = 0; i < dots.length; i++) {
      double x = distance * i + distance / 2;
      path.lineTo(x, dots.elementAt(i).top);
    }

    path.lineTo(size.width, dots.elementAt(5).top);
    path.lineTo(size.width, dots.elementAt(5).bot + margin);

    for (int i = 0; i < dots.length; i++) {
      double x = distance * (5 - i) + distance / 2;
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
