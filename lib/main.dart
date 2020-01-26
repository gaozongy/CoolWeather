import 'package:coolweather/main_page.dart';
import 'package:coolweather/warning_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'about_page.dart';
import 'add_district_page.dart';
import 'data/unit_model.dart';
import 'focus_district_list_page.dart';
import 'more_day_forecast_page.dart';
import 'setting_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// 单位model
  final unitModel = UnitModel();
  unitModel.initUnit();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));

//  initJPush();

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
//        "/": (context) => TestPage(),
        "/": (context) => MainPage(),
        "more_day_forecast": (context) => MoreDayForecast(),
        "focus_district_list": (context) => FocusDistrictListPage(),
        "select_district": (context) => AddDistrictPage(),
        "setting": (context) => SettingPage(),
        "about": (context) => AboutPage(),
        "warning": (context) => WarningPage(),
      },
    ),
  ));
}

//initJPush() {
//  JPush jpush = new JPush();
//  jpush.addEventHandler(
//    // 接收通知回调方法。
//    onReceiveNotification: (Map<String, dynamic> message) async {
//      print("flutter onReceiveNotification: $message");
//    },
//    // 点击通知回调方法。
//    onOpenNotification: (Map<String, dynamic> message) async {
//      print("flutter onOpenNotification: $message");
//    },
//    // 接收自定义消息回调方法。
//    onReceiveMessage: (Map<String, dynamic> message) async {
//      print("flutter onReceiveMessage: $message");
//    },
//  );
//  jpush.setup(
//    appKey: "43ae1d5376e4359e8bd732c1",
//    channel: "theChannel",
//    production: false,
//    debug: true,
//  );
//  jpush.getRegistrationID().then((rid) { });
//}
