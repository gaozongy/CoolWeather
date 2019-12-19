import 'package:flutter/material.dart';

// todo
abstract class BaseAnimState<StatefulWidget> extends State with TickerProviderStateMixin {

  double maskAlpha = 1;

  void setMaskAlpha(double maskAlpha) {
    setState(() {
      this.maskAlpha = maskAlpha;
    });
  }
}