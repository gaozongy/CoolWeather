import 'package:flutter/material.dart';

/// 统一天气动画控制alpha方法
abstract class BaseAnimState<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  double maskAlpha = 1;

  void setMaskAlpha(double maskAlpha) {
    setState(() {
      this.maskAlpha = maskAlpha;
    });
  }
}