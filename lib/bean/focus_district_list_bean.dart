import 'package:coolweather/bean/realtime.dart';
import 'package:json_annotation/json_annotation.dart';

part 'focus_district_list_bean.g.dart';

@JsonSerializable()
class FocusDistrictListBean {
  List<District> districtList;

  FocusDistrictListBean(this.districtList);

  factory FocusDistrictListBean.fromJson(Map<String, dynamic> json) =>
      _$FocusDistrictListBeanFromJson(json);

  Map<String, dynamic> toJson() => _$FocusDistrictListBeanToJson(this);
}

@JsonSerializable()
class District {
  String name;
  double latitude;
  double longitude;

  District(this.name, this.latitude, this.longitude);

  factory District.fromJson(Map<String, dynamic> json) => _$DistrictFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictToJson(this);
}

/// 区域信息 + 天气信息
class DistrictWeather {
  District district;
  Realtime realtime;

  DistrictWeather(this.district, this.realtime);
}