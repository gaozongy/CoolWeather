import 'package:flutter/material.dart';

import 'cloudy_paint.dart';

class CloudyBg extends StatefulWidget {
  @override
  _CloudyBgState createState() => _CloudyBgState();
}

class _CloudyBgState extends State<CloudyBg> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        size: Size(double.infinity, 100),
        painter: CloudyPainter(),
      ),
      decoration: BoxDecoration(color: Color(0xFF4B97D1)),
    );
  }
}
