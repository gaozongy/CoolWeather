import 'package:json_annotation/json_annotation.dart';

part 'hourly.g.dart';

@JsonSerializable()
class Hourly {
  String status;
  String description;
  List<StringValue> skycon;
  List<DoubleValue> cloudrate;
  List<IntValue> aqi;
  List<DoubleValue> dswrf;
  List<DoubleValue> visibility;
  List<DoubleValue> humidity;
  List<DoubleValue> pres;
  List<IntValue> pm25;
  List<DoubleValue> precipitation;
  List<Wind> wind;
  List<DoubleValue> temperature;

  Hourly(this.status, this.description, this.skycon, this.cloudrate, this.aqi,
      this.dswrf, this.visibility, this.humidity, this.pres, this.pm25,
      this.precipitation, this.wind, this.temperature);

  factory Hourly.fromJson(Map<String, dynamic> json) => _$HourlyFromJson(json);
  Map<String, dynamic> toJson() => _$HourlyToJson(this);
}

@JsonSerializable()
class StringValue{
  String value;
  String datetime;

  StringValue(this.value, this.datetime);

  factory StringValue.fromJson(Map<String, dynamic> json) => _$StringValueFromJson(json);
  Map<String, dynamic> toJson() => _$StringValueToJson(this);
}

@JsonSerializable()
class IntValue{
  int value;
  String datetime;

  IntValue(this.value, this.datetime);

  factory IntValue.fromJson(Map<String, dynamic> json) => _$IntValueFromJson(json);
  Map<String, dynamic> toJson() => _$IntValueToJson(this);
}

@JsonSerializable()
class DoubleValue{
  double value;
  String datetime;

  DoubleValue(this.value, this.datetime);

  factory DoubleValue.fromJson(Map<String, dynamic> json) => _$DoubleValueFromJson(json);
  Map<String, dynamic> toJson() => _$DoubleValueToJson(this);
}

@JsonSerializable()
class Wind{
  double direction;
  double speed;
  String datetime;

  Wind(this.direction, this.speed, this.datetime);

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
  Map<String, dynamic> toJson() => _$WindToJson(this);
}

