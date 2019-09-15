import 'package:json_annotation/json_annotation.dart';

part 'focus_county_list_bean.g.dart';

@JsonSerializable()
class FocusCountyListBean {
  List<County> countyList;

  FocusCountyListBean(this.countyList);

  factory FocusCountyListBean.fromJson(Map<String, dynamic> json) =>
      _$FocusCountyListBeanFromJson(json);

  Map<String, dynamic> toJson() => _$FocusCountyListBeanToJson(this);
}

@JsonSerializable()
class County {
  String countyName;
  double latitude;
  double longitude;

  County(this.countyName, this.latitude, this.longitude);

  factory County.fromJson(Map<String, dynamic> json) => _$CountyFromJson(json);

  Map<String, dynamic> toJson() => _$CountyToJson(this);
}
