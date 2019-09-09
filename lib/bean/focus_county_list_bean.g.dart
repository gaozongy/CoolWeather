// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_county_list_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FocusCountyListBean _$FocusCountyListBeanFromJson(Map<String, dynamic> json) {
  return FocusCountyListBean((json['countyList'] as List)
      ?.map(
          (e) => e == null ? null : County.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, List<County>> _$FocusCountyListBeanToJson(
        FocusCountyListBean instance) =>
    <String, List<County>>{'countyList': instance.countyList};

County _$CountyFromJson(Map<String, dynamic> json) {
  return County(json['countyName'] as String, json['weatherId'] as String);
}

Map<String, dynamic> _$CountyToJson(County instance) => <String, dynamic>{
      'countyName': instance.countyName,
      'weatherId': instance.weatherId
    };
