import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'about.dart';
import 'focus_district_list.dart';
import 'select_district.dart';
import 'setting.dart';
import 'unit_model.dart';
import 'weather_detail.dart';

void main() {
  /// 单位model
  final unitModel = UnitModel();
  unitModel.initUnit();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));

  runApp(ChangeNotifierProvider<UnitModel>.value(
    value: unitModel,
    child: MaterialApp(
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
        "select_district": (context) => SelectDistrict(),
        "setting": (context) => Setting(),
        "about": (context) => About(),
      },
    ),
  ));
}
