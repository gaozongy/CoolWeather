import 'package:coolweather/focus_county_list.dart';
import 'package:coolweather/select_county.dart';
import 'package:coolweather/views/temp_line.dart';
import 'package:coolweather/weather_detail.dart';
import 'package:flutter/material.dart';

import 'custom_paint_widget.dart';

void main() => runApp(MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => Container(
              color: Colors.blueAccent,
              child: TempLineWidget(),
            ),
        "focus_county_list": (context) => FocusCountyList(),
        "select_county": (context) => SelectCounty()
      },
    ));
