import 'package:flutter/material.dart';

// todo 研究一下dart的继承，多态
abstract class BaseAnimState<StatefulWidget> extends State with TickerProviderStateMixin {

  double maskAlpha = 1;

  void setMaskAlpha(double maskAlpha) {
    setState(() {
      this.maskAlpha = maskAlpha;
    });
  }
}