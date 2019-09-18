
import 'package:coolweather/bean/hourly.dart';
import 'package:coolweather/bean/realtime.dart';

import 'minutely.dart';

class WeatherBean{
  String status;
  String lang;
  String server_time;
  String api_status;
  int tzshirt;
  String api_version;
  String unit;
  Result result;
  List<double> location;
}

class Result {
  String forecast_keypoint;
  int primary;
  Realtime realtime;
  Minutely minutely;
  Hourly hourly;

}

