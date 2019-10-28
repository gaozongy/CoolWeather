import 'package:flutter/material.dart';

/// 屏幕工具类
class ScreenUtils {
  /// 获取屏幕宽度
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// 获取屏幕高度
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// 获取系统状态栏高度
  static double getSysStatsHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double pxToLogicalPixels(BuildContext context, double px) {
    // 一加 3.8 红米 3.0
    return px / MediaQuery.of(context).devicePixelRatio;
  }
}
