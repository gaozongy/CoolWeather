import 'package:json_annotation/json_annotation.dart';

part 'focus_county_list_bean.g.dart';

@JsonSerializable()
class FocusCountyListBean {

  List<County> countyList;

  FocusCountyListBean(this.countyList);

  factory FocusCountyListBean.fromJson(Map<String, dynamic> json) => _$FocusCountyListBeanFromJson(json);
  Map<String, List<County>> toJson() => _$FocusCountyListBeanToJson(this);
}

@JsonSerializable()
class County {
  String countyName;

  String weatherId;

  County(this.countyName, this.weatherId);

  factory County.fromJson(Map<String, dynamic> json) => _$CountyFromJson(json);
  Map<String, dynamic> toJson() => _$CountyToJson(this);
}