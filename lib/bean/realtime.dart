import 'package:json_annotation/json_annotation.dart';

part 'realtime.g.dart';

@JsonSerializable()
class Realtime{
  String status;
  double o3;
  double co;
  double temperature;
  double pm10;
  String skycon;
  double cloudrate;
  Precipitation precipitation;
  double dswrf;
  double visibility;
  double humidity;
  double so2;
  Ultraviolet ultraviolet;
  double pres;
  int aqi;
  int pm25;
  double no2;
  double apparent_temperature;
  Comfort comfort;
  Wind wind;

  Realtime(this.status, this.o3, this.co, this.temperature, this.pm10,
      this.skycon, this.cloudrate, this.precipitation, this.dswrf,
      this.visibility, this.humidity, this.so2, this.ultraviolet, this.pres,
      this.aqi, this.pm25, this.no2, this.apparent_temperature, this.comfort,
      this.wind);

  factory Realtime.fromJson(Map<String, dynamic> json) => _$RealtimeFromJson(json);
  Map<String, dynamic> toJson() => _$RealtimeToJson(this);
}

@JsonSerializable()
class Precipitation {
  Nearest nearest;
  Local local;

  Precipitation(this.nearest, this.local);

  factory Precipitation.fromJson(Map<String, dynamic> json) => _$PrecipitationFromJson(json);
  Map<String, dynamic> toJson() => _$PrecipitationToJson(this);
}

@JsonSerializable()
class Nearest {
  String status;
  double distance;
  double intensity;

  Nearest(this.status, this.distance, this.intensity);

  factory Nearest.fromJson(Map<String, dynamic> json) => _$NearestFromJson(json);
  Map<String, dynamic> toJson() => _$NearestToJson(this);
}

@JsonSerializable()
class Local {
  String status;
  double intensity;
  String datasource;

  Local(this.status, this.intensity, this.datasource);

  factory Local.fromJson(Map<String, dynamic> json) => _$LocalFromJson(json);
  Map<String, dynamic> toJson() => _$LocalToJson(this);
}

@JsonSerializable()
class Ultraviolet {
  double index;
  String desc;

  Ultraviolet(this.index, this.desc);

  factory Ultraviolet.fromJson(Map<String, dynamic> json) => _$UltravioletFromJson(json);
  Map<String, dynamic> toJson() => _$UltravioletToJson(this);
}

@JsonSerializable()
class Comfort{
  int index;
  String desc;

  Comfort(this.index, this.desc);

  factory Comfort.fromJson(Map<String, dynamic> json) => _$ComfortFromJson(json);
  Map<String, dynamic> toJson() => _$ComfortToJson(this);
}

@JsonSerializable()
class Wind {
  double direction;
  double speed;

  Wind(this.direction, this.speed);

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
  Map<String, dynamic> toJson() => _$WindToJson(this);
}