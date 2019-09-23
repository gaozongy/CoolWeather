import 'package:json_annotation/json_annotation.dart';

part 'daily.g.dart';

@JsonSerializable()
class Daily {
  String status;
  List<Comfort> comfort;
  List<Skycon_20h_32h> skycon_20h_32h;
  List<Temperature> temperature;
  List<Dswrf> dswrf;
  List<Cloudrate> cloudrate;
  List<Aqi> aqi;
  List<Skycon> skycon;
  List<Visibility> visibility;
  List<Humidity> humidity;
  List<Astro> astro;
  List<ColdRisk> coldRisk;
  List<Ultraviolet> ultraviolet;
  List<Pm25> pm25;
  List<Dressing> dressing;
  List<CarWashing> carWashing;
  List<Precipitation> precipitation;
  List<Wind> wind;
  List<Skycon_08h_20h> skycon_08h_20h;

  Daily(this.status, this.comfort, this.skycon_20h_32h, this.temperature,
      this.dswrf, this.cloudrate, this.aqi, this.skycon, this.visibility,
      this.humidity, this.astro, this.coldRisk, this.ultraviolet, this.pm25,
      this.dressing, this.carWashing, this.precipitation, this.wind,
      this.skycon_08h_20h);

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);
  Map<String, dynamic> toJson() => _$DailyToJson(this);
}

@JsonSerializable()
class Comfort {
  String index;
  String desc;
  String datetime;

  Comfort(this.index, this.desc, this.datetime);

  factory Comfort.fromJson(Map<String, dynamic> json) => _$ComfortFromJson(json);
  Map<String, dynamic> toJson() => _$ComfortToJson(this);
}

@JsonSerializable()
class Skycon_20h_32h {
  String date;
  String value;

  Skycon_20h_32h(this.date, this.value);

  factory Skycon_20h_32h.fromJson(Map<String, dynamic> json) => _$Skycon_20h_32hFromJson(json);
  Map<String, dynamic> toJson() => _$Skycon_20h_32hToJson(this);
}

@JsonSerializable()
class Temperature {
  String date;
  double max;
  double avg;
  double min;

  Temperature(this.date, this.max, this.avg, this.min);

  factory Temperature.fromJson(Map<String, dynamic> json) => _$TemperatureFromJson(json);
  Map<String, dynamic> toJson() => _$TemperatureToJson(this);
}

@JsonSerializable()
class Dswrf {
  String date;
  double max;
  double avg;
  double min;

  Dswrf(this.date, this.max, this.avg, this.min);

  factory Dswrf.fromJson(Map<String, dynamic> json) => _$DswrfFromJson(json);
  Map<String, dynamic> toJson() => _$DswrfToJson(this);
}

@JsonSerializable()
class Cloudrate {
  String date;
  double max;
  double avg;
  double min;

  Cloudrate(this.date, this.max, this.avg, this.min);

  factory Cloudrate.fromJson(Map<String, dynamic> json) => _$CloudrateFromJson(json);
  Map<String, dynamic> toJson() => _$CloudrateToJson(this);
}

@JsonSerializable()
class Aqi {
  String date;
  int max;
  double avg;
  int min;

  Aqi(this.date, this.max, this.avg, this.min);

  factory Aqi.fromJson(Map<String, dynamic> json) => _$AqiFromJson(json);
  Map<String, dynamic> toJson() => _$AqiToJson(this);
}

@JsonSerializable()
class Skycon {
  String date;
  String value;

  Skycon(this.date, this.value);

  factory Skycon.fromJson(Map<String, dynamic> json) => _$SkyconFromJson(json);
  Map<String, dynamic> toJson() => _$SkyconToJson(this);
}

@JsonSerializable()
class Visibility {
  String date;
  double max;
  double avg;
  double min;

  Visibility(this.date, this.max, this.avg, this.min);

  factory Visibility.fromJson(Map<String, dynamic> json) => _$VisibilityFromJson(json);
  Map<String, dynamic> toJson() => _$VisibilityToJson(this);
}

@JsonSerializable()
class Humidity {
  String date;
  double max;
  double avg;
  double min;

  Humidity(this.date, this.max, this.avg, this.min);

  factory Humidity.fromJson(Map<String, dynamic> json) => _$HumidityFromJson(json);
  Map<String, dynamic> toJson() => _$HumidityToJson(this);
}

@JsonSerializable()
class Astro {
  String date;
  Sunset sunset;
  Sunrise sunrise;

  Astro(this.date, this.sunset, this.sunrise);

  factory Astro.fromJson(Map<String, dynamic> json) => _$AstroFromJson(json);
  Map<String, dynamic> toJson() => _$AstroToJson(this);
}

@JsonSerializable()
class Sunset {
  String time;

  Sunset(this.time);

  factory Sunset.fromJson(Map<String, dynamic> json) => _$SunsetFromJson(json);
  Map<String, dynamic> toJson() => _$SunsetToJson(this);
}

@JsonSerializable()
class Sunrise {
  String time;

  Sunrise(this.time);

  factory Sunrise.fromJson(Map<String, dynamic> json) => _$SunriseFromJson(json);
  Map<String, dynamic> toJson() => _$SunriseToJson(this);
}

@JsonSerializable()
class ColdRisk {
  String index;
  String desc;
  String datetime;

  ColdRisk(this.index, this.desc, this.datetime);

  factory ColdRisk.fromJson(Map<String, dynamic> json) => _$ColdRiskFromJson(json);
  Map<String, dynamic> toJson() => _$ColdRiskToJson(this);
}

@JsonSerializable()
class Ultraviolet {
  String index;
  String desc;
  String datetime;

  Ultraviolet(this.index, this.desc, this.datetime);

  factory Ultraviolet.fromJson(Map<String, dynamic> json) => _$UltravioletFromJson(json);
  Map<String, dynamic> toJson() => _$UltravioletToJson(this);
}

@JsonSerializable()
class Pres {
  String date;
  double max;
  double avg;
  double min;

  Pres(this.date, this.max, this.avg, this.min);

  factory Pres.fromJson(Map<String, dynamic> json) => _$PresFromJson(json);
  Map<String, dynamic> toJson() => _$PresToJson(this);
}

@JsonSerializable()
class Pm25 {
  String date;
  int max;
  double avg;
  int min;

  Pm25(this.date, this.max, this.avg, this.min);

  factory Pm25.fromJson(Map<String, dynamic> json) => _$Pm25FromJson(json);
  Map<String, dynamic> toJson() => _$Pm25ToJson(this);
}

@JsonSerializable()
class Dressing {
  String index;
  String desc;
  String datetime;

  Dressing(this.index, this.desc, this.datetime);

  factory Dressing.fromJson(Map<String, dynamic> json) => _$DressingFromJson(json);
  Map<String, dynamic> toJson() => _$DressingToJson(this);
}

@JsonSerializable()
class CarWashing {
  String index;
  String desc;
  String datetime;

  CarWashing(this.index, this.desc, this.datetime);

  factory CarWashing.fromJson(Map<String, dynamic> json) => _$CarWashingFromJson(json);
  Map<String, dynamic> toJson() => _$CarWashingToJson(this);
}

@JsonSerializable()
class Precipitation {
  String date;
  double max;
  double avg;
  double min;

  Precipitation(this.date, this.max, this.avg, this.min);

  factory Precipitation.fromJson(Map<String, dynamic> json) => _$PrecipitationFromJson(json);
  Map<String, dynamic> toJson() => _$PrecipitationToJson(this);
}

@JsonSerializable()
class Wind {
  String date;
  WindValue max;
  WindValue avg;
  WindValue min;

  Wind(this.date, this.max, this.avg, this.min);

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
  Map<String, dynamic> toJson() => _$WindToJson(this);
}

@JsonSerializable()
class WindValue {
  double direction;
  double speed;

  WindValue(this.direction, this.speed);

  factory WindValue.fromJson(Map<String, dynamic> json) => _$WindValueFromJson(json);
  Map<String, dynamic> toJson() => _$WindValueToJson(this);
}

@JsonSerializable()
class Skycon_08h_20h {
  String date;
  String value;

  Skycon_08h_20h(this.date, this.value);

  factory Skycon_08h_20h.fromJson(Map<String, dynamic> json) => _$Skycon_08h_20hFromJson(json);
  Map<String, dynamic> toJson() => _$Skycon_08h_20hToJson(this);
}
