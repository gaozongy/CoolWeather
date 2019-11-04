import 'package:coolweather/utils/date_utils.dart';
import 'package:coolweather/utils/image_utils.dart';
import 'package:coolweather/utils/screen_utils.dart';
import 'package:coolweather/utils/translation_utils.dart';
import 'package:coolweather/views/temperature_line.dart';
import 'package:coolweather/views/temperature_line_c.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bean/daily.dart';

class MoreDayForecast extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Daily daily = ModalRoute.of(context).settings.arguments;
    double screenWidth = ScreenUtils.getScreenWidth(context);
    double itemWidth = screenWidth / 6;

    return Material(
      child: Container(
        color: Colors.blue,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[_forecastLayout(itemWidth, daily), _tempLineLayout(itemWidth, daily)],
          ),
        ),
      ),
    );
  }

  Widget _forecastLayout(double itemWidth, Daily daily) {
    List<Widget> forecastRow = new List();
    int length = daily.skycon.length;

    for (int i = 0; i < length; i++) {
      Skycon skycon = daily.skycon.elementAt(i);
      double intensity = daily.precipitation.elementAt(i).max;
      DateTime dateTime = DateTime.parse(skycon.date);
      ImageIcon weatherIcon = _getWeatherIcon(skycon.value);

      forecastRow.add(SizedBox(
        width: itemWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _textLayout(DateUtils.getWhichDay(dateTime.weekday - 1)),
            _textLayout('${dateTime.month}' + '月' + '${dateTime.day}' + '日'),
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 2),
              //child: Icon(imageIcon, color: Colors.white),
              child: weatherIcon,
            ),
            _textLayout(Translation.getWeatherDesc(skycon.value, intensity)),
          ],
        ),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: forecastRow,
    );
  }

  Widget _textLayout(String content) {
    return Text(content, style: TextStyle(color: Colors.white, fontSize: 12));
  }

  ImageIcon _getWeatherIcon(String weather) {
    return ImageIcon(
      AssetImage(ImageUtils.getWeatherIconUri(weather)),
      size: 22,
      color: Colors.white,
    );
  }

  // 气温折线图
  Widget _tempLineLayout(double itemWidth, Daily daily) {
    List<Temp> tempList = List();

    var forecast = daily.temperature;
    for (int i = 0; i < forecast.length; i++) {
      tempList.add(Temp(forecast.elementAt(i).max, forecast.elementAt(i).min));
    }
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 20),
      child: TemperatureLineC(itemWidth, tempList),
    );
  }
}
