import 'package:coolweather/select_county.dart';
import 'package:coolweather/weather_detail.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => WeatherDetail(),
        "select_county": (context) => SelectCounty()
      },
    ));
