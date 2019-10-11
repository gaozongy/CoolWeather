import 'package:coolweather/focus_district_list.dart';
import 'package:coolweather/select_district.dart';
import 'package:coolweather/weather_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));

  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      accentColor: Colors.white,
      fontFamily: 'Montserrat',
      textTheme: TextTheme(
        headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
    ),
    initialRoute: "/",
    routes: {
      "/": (context) => WeatherDetail(),
      "focus_district_list": (context) => FocusDistrictList(),
      "select_district": (context) => SelectDistrict()
    },
  ));
}
