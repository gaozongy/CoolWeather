import 'package:coolweather/focus_district_list.dart';
import 'package:coolweather/select_district.dart';
import 'package:coolweather/weather_detail.dart';
import 'package:flutter/material.dart';


void main() => runApp(MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => WeatherDetail(),
        "focus_district_list": (context) => FocusDistrictList(),
        "select_district": (context) => SelectDistrict()
      },
    ));
