
import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'minutely.g.dart';

@JsonSerializable()
class Minutely {
  String status;
  String description;
  List<double> probability;
  String datasource;
  List<double> precipitation_2h;
  List<double> precipitation;

  Minutely(this.status, this.description, this.probability, this.datasource,
      this.precipitation_2h, this.precipitation);

  factory Minutely.fromJson(Map<String, dynamic> json) => _$MinutelyFromJson(json);
  Map<String, dynamic> toJson() => _$MinutelyToJson(this);
}