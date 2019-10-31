import 'package:flutter/material.dart';

class LogoApp extends StatefulWidget {
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    // 曲线动画的核心的代码
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => AnimatedLogo(
        animation: animation,
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimatedLogo extends AnimatedWidget {
  // 曲线动画使用的过渡效果
  static final _sizeTween = Tween<double>(begin: 0, end: 300);

  // 构造参数中的第二个参数为Animation，传递给父构造函数的listenable
  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    // 通过listenable获取value
    final Animation<double> animation = listenable;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        // 曲线动画部分开始
        height: _sizeTween.evaluate(animation),
        width: _sizeTween.evaluate(animation),
        // 曲线动画部分结束
        child: FlutterLogo(),
      ),
    );
  }
}
