import 'dart:typed_data';

import 'dart:ui';

import 'package:coolweather/bean/weather_bean.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'date_utils.dart';
import 'image_utils.dart';
import 'translation_utils.dart';

/// 分享工具类
class ShareUtils {
  /// 创建天气分享卡片
  static Future<Uint8List> createWeatherCard(
      String districtName, WeatherBean weatherBean) async {
    PictureRecorder recorder = new PictureRecorder();

    Canvas canvas = new Canvas(recorder);

    Result result = weatherBean.result;
    // 天气描述
    String weather = result.realtime.skycon;
    // 降雨（雪）强度
    double intensity = result.realtime.precipitation.local.intensity;
    // 是否是白天
    bool isDay = DateUtils.isDay(weatherBean);

    // 背景图片
    final ByteData bgByteData = await rootBundle
        .load(ImageUtils.getWeatherShareBgUri(weather, intensity, isDay));
    if (bgByteData == null) throw 'Unable to read data';
    var codec = await instantiateImageCodec(bgByteData.buffer.asUint8List());
    FrameInfo frame = await codec.getNextFrame();
    canvas.drawImage(frame.image, new Offset(0, 0), new Paint());

    TextPainter districtTp = createTextPainter(
        districtName, 45, FontWeight.w600,
        text2: '    ' + DateUtils.getCurrentTimeMMDD(), fontSize2: 35);
    districtTp.paint(canvas, Offset(50, 40));

    TextPainter temperatureTp = createTextPainter(
      weatherBean.result.realtime.temperature.toStringAsFixed(0) + "°",
      140,
      FontWeight.w300,
    );
    temperatureTp.paint(canvas, Offset(50, 180));

    TextPainter weatherTp = createTextPainter(
        Translation.getWeatherDesc(weatherBean.result.realtime.skycon,
                weatherBean.result.realtime.precipitation.local.intensity) +
            '  ' +
            weatherBean.result.daily.temperature
                .elementAt(0)
                .max
                .toStringAsFixed(0) +
            ' / ' +
            weatherBean.result.daily.temperature
                .elementAt(0)
                .min
                .toStringAsFixed(0) +
            '℃',
        45,
        FontWeight.w400);
    weatherTp.paint(canvas, Offset(50, 350));

    Picture picture = recorder.endRecording();
    ByteData byteData = await (await picture.toImage(1038, 450))
        .toByteData(format: ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }

  static TextPainter createTextPainter(
    String text,
    double fontSize,
    FontWeight fontWeight, {
    String text2,
    double fontSize2,
  }) {
    return TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(children: [
        TextSpan(
          text: text,
          style: TextStyle(
              color: Colors.white, fontSize: fontSize, fontWeight: fontWeight),
        ),
        TextSpan(
          text: text2,
          style: TextStyle(
            color: Colors.white70,
            fontSize: fontSize2,
          ),
        )
      ]),
    )..layout();
  }
}
