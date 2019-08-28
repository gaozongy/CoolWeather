import 'package:json_annotation/json_annotation.dart';

part 'weather_mode.g.dart';

@JsonSerializable()
class WeatherMode {

  List<Inf> HeWeather;

  WeatherMode(this.HeWeather);

  factory WeatherMode.fromJson(Map<String, dynamic> json) => _$WeatherModeFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherModeToJson(this);
}

@JsonSerializable()
class Inf {

  Basic basic;
  Update update;
  String status;
  Now now;
  List<Daily> daily_forecast;
  Aqi aqi;
  Suggestion suggestion;
  String msg;

  Inf(this.basic, this.update, this.status, this.now, this.daily_forecast,
      this.aqi, this.suggestion, this.msg);

  factory Inf.fromJson(Map<String, dynamic> json) => _$InfFromJson(json);
  Map<String, dynamic> toJson() => _$InfToJson(this);
}

@JsonSerializable()
class Basic {
  String cid;
  String location;
  String parent_city;
  String admin_area;
  String cnty;
  String lat;
  String lon;
  String tz;
  String city;
  String id;
  Update update;


  Basic(this.cid, this.location, this.parent_city, this.admin_area, this.cnty,
      this.lat, this.lon, this.tz, this.city, this.id, this.update);

  factory Basic.fromJson(Map<String, dynamic> json) => _$BasicFromJson(json);
  Map<String, dynamic> toJson() => _$BasicToJson(this);
}

@JsonSerializable()
class Update {
  String loc;
  String utc;

  Update(this.loc, this.utc);

  factory Update.fromJson(Map<String, dynamic> json) => _$UpdateFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateToJson(this);
}

@JsonSerializable()
class Now {
  String cloud;
  String cond_code;
  String cond_txt;
  String fl;
  String hum;
  String pcpn;
  String pres;
  String tmp;
  String vis;
  String wind_deg;
  String wind_dir;
  String wind_sc;
  String wind_spd;
  Cond cond;

  Now(this.cloud, this.cond_code, this.cond_txt, this.fl, this.hum, this.pcpn,
      this.pres, this.tmp, this.vis, this.wind_deg, this.wind_dir, this.wind_sc,
      this.wind_spd, this.cond);

  factory Now.fromJson(Map<String, dynamic> json) => _$NowFromJson(json);
  Map<String, dynamic> toJson() => _$NowToJson(this);
}

@JsonSerializable()
class Cond {
  String code;
  String txt;

  Cond(this.code, this.txt);

  factory Cond.fromJson(Map<String, dynamic> json) => _$CondFromJson(json);
  Map<String, dynamic> toJson() => _$CondToJson(this);
}

@JsonSerializable()
class Daily {
  String date;
  _Cond cond;
  Tmp tmp;

  Daily(this.date, this.cond, this.tmp);

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);
  Map<String, dynamic> toJson() => _$DailyToJson(this);
}

@JsonSerializable()
class _Cond {
  String txt_d;

  _Cond(this.txt_d);

  factory _Cond.fromJson(Map<String, dynamic> json) => _$_CondFromJson(json);
  Map<String, dynamic> toJson() => _$_CondToJson(this);
}

@JsonSerializable()
class Tmp {
  String max;
  String min;

  Tmp(this.max, this.min);

  factory Tmp.fromJson(Map<String, dynamic> json) => _$TmpFromJson(json);
  Map<String, dynamic> toJson() => _$TmpToJson(this);
}

@JsonSerializable()
class Aqi {
  City city;

  Aqi(this.city);

  factory Aqi.fromJson(Map<String, dynamic> json) => _$AqiFromJson(json);
  Map<String, dynamic> toJson() => _$AqiToJson(this);
}

@JsonSerializable()
class City {
  String aqi;
  String pm25;
  String qlty;

  City(this.aqi, this.pm25, this.qlty);

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
  Map<String, dynamic> toJson() => _$CityToJson(this);
}

@JsonSerializable()
class Suggestion {
  Suggest comf;
  Suggest sport;
  Suggest cw;

  Suggestion(this.comf, this.sport, this.cw);

  factory Suggestion.fromJson(Map<String, dynamic> json) => _$SuggestionFromJson(json);
  Map<String, dynamic> toJson() => _$SuggestionToJson(this);
}

@JsonSerializable()
class Suggest {
  String type;
  String brf;
  String txt;

  Suggest(this.type, this.brf, this.txt);

  factory Suggest.fromJson(Map<String, dynamic> json) => _$SuggestFromJson(json);
  Map<String, dynamic> toJson() => _$SuggestToJson(this);
}
