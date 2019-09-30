
import 'package:coolweather/bean/daily.dart';
import 'package:coolweather/bean/hourly.dart';
import 'package:coolweather/bean/realtime.dart';
import 'package:json_annotation/json_annotation.dart';

import 'minutely.dart';

part 'weather_bean.g.dart';

@JsonSerializable()
class WeatherBean{
  String status;
  String lang;
  int server_time;
  String api_status;
  int tzshift;
  String api_version;
  String unit;
  Result result;
  List<double> location;

  WeatherBean(this.status, this.lang, this.server_time, this.api_status,
      this.tzshift, this.api_version, this.unit, this.result, this.location);

  factory WeatherBean.fromJson(Map<String, dynamic> json) => _$WeatherBeanFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherBeanToJson(this);
}

@JsonSerializable()
class Result {
  String forecast_keypoint;
  int primary;
  Realtime realtime;
  Minutely minutely;
  Hourly hourly;
  Daily daily;

  Result(this.forecast_keypoint, this.primary, this.realtime, this.minutely,
      this.hourly, this.daily);

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

