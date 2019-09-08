// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherBean _$WeatherBeanFromJson(Map<String, dynamic> json) {
  return WeatherBean((json['HeWeather'] as List)
      ?.map((e) => e == null ? null : Inf.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$WeatherBeanToJson(WeatherBean instance) =>
    <String, dynamic>{'HeWeather': instance.HeWeather};

Inf _$InfFromJson(Map<String, dynamic> json) {
  return Inf(
      json['basic'] == null
          ? null
          : Basic.fromJson(json['basic'] as Map<String, dynamic>),
      json['update'] == null
          ? null
          : Update.fromJson(json['update'] as Map<String, dynamic>),
      json['status'] as String,
      json['now'] == null
          ? null
          : Now.fromJson(json['now'] as Map<String, dynamic>),
      (json['daily_forecast'] as List)
          ?.map((e) =>
              e == null ? null : Daily.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['aqi'] == null
          ? null
          : Aqi.fromJson(json['aqi'] as Map<String, dynamic>),
      json['suggestion'] == null
          ? null
          : Suggestion.fromJson(json['suggestion'] as Map<String, dynamic>),
      json['msg'] as String);
}

Map<String, dynamic> _$InfToJson(Inf instance) => <String, dynamic>{
      'basic': instance.basic,
      'update': instance.update,
      'status': instance.status,
      'now': instance.now,
      'daily_forecast': instance.daily_forecast,
      'aqi': instance.aqi,
      'suggestion': instance.suggestion,
      'msg': instance.msg
    };

Basic _$BasicFromJson(Map<String, dynamic> json) {
  return Basic(
      json['cid'] as String,
      json['location'] as String,
      json['parent_city'] as String,
      json['admin_area'] as String,
      json['cnty'] as String,
      json['lat'] as String,
      json['lon'] as String,
      json['tz'] as String,
      json['city'] as String,
      json['id'] as String,
      json['update'] == null
          ? null
          : Update.fromJson(json['update'] as Map<String, dynamic>));
}

Map<String, dynamic> _$BasicToJson(Basic instance) => <String, dynamic>{
      'cid': instance.cid,
      'location': instance.location,
      'parent_city': instance.parent_city,
      'admin_area': instance.admin_area,
      'cnty': instance.cnty,
      'lat': instance.lat,
      'lon': instance.lon,
      'tz': instance.tz,
      'city': instance.city,
      'id': instance.id,
      'update': instance.update
    };

Update _$UpdateFromJson(Map<String, dynamic> json) {
  return Update(json['loc'] as String, json['utc'] as String);
}

Map<String, dynamic> _$UpdateToJson(Update instance) =>
    <String, dynamic>{'loc': instance.loc, 'utc': instance.utc};

Now _$NowFromJson(Map<String, dynamic> json) {
  return Now(
      json['cloud'] as String,
      json['cond_code'] as String,
      json['cond_txt'] as String,
      json['fl'] as String,
      json['hum'] as String,
      json['pcpn'] as String,
      json['pres'] as String,
      json['tmp'] as String,
      json['vis'] as String,
      json['wind_deg'] as String,
      json['wind_dir'] as String,
      json['wind_sc'] as String,
      json['wind_spd'] as String,
      json['cond'] == null
          ? null
          : Cond.fromJson(json['cond'] as Map<String, dynamic>));
}

Map<String, dynamic> _$NowToJson(Now instance) => <String, dynamic>{
      'cloud': instance.cloud,
      'cond_code': instance.cond_code,
      'cond_txt': instance.cond_txt,
      'fl': instance.fl,
      'hum': instance.hum,
      'pcpn': instance.pcpn,
      'pres': instance.pres,
      'tmp': instance.tmp,
      'vis': instance.vis,
      'wind_deg': instance.wind_deg,
      'wind_dir': instance.wind_dir,
      'wind_sc': instance.wind_sc,
      'wind_spd': instance.wind_spd,
      'cond': instance.cond
    };

Cond _$CondFromJson(Map<String, dynamic> json) {
  return Cond(json['code'] as String, json['txt'] as String);
}

Map<String, dynamic> _$CondToJson(Cond instance) =>
    <String, dynamic>{'code': instance.code, 'txt': instance.txt};

Daily _$DailyFromJson(Map<String, dynamic> json) {
  return Daily(
      json['date'] as String,
      json['cond'] == null
          ? null
          : _Cond.fromJson(json['cond'] as Map<String, dynamic>),
      json['tmp'] == null
          ? null
          : Tmp.fromJson(json['tmp'] as Map<String, dynamic>));
}

Map<String, dynamic> _$DailyToJson(Daily instance) => <String, dynamic>{
      'date': instance.date,
      'cond': instance.cond,
      'tmp': instance.tmp
    };

_Cond _$_CondFromJson(Map<String, dynamic> json) {
  return _Cond(json['txt_d'] as String);
}

Map<String, dynamic> _$_CondToJson(_Cond instance) =>
    <String, dynamic>{'txt_d': instance.txt_d};

Tmp _$TmpFromJson(Map<String, dynamic> json) {
  return Tmp(json['max'] as String, json['min'] as String);
}

Map<String, dynamic> _$TmpToJson(Tmp instance) =>
    <String, dynamic>{'max': instance.max, 'min': instance.min};

Aqi _$AqiFromJson(Map<String, dynamic> json) {
  return Aqi(json['city'] == null
      ? null
      : City.fromJson(json['city'] as Map<String, dynamic>));
}

Map<String, dynamic> _$AqiToJson(Aqi instance) =>
    <String, dynamic>{'city': instance.city};

City _$CityFromJson(Map<String, dynamic> json) {
  return City(
      json['aqi'] as String, json['pm25'] as String, json['qlty'] as String);
}

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'aqi': instance.aqi,
      'pm25': instance.pm25,
      'qlty': instance.qlty
    };

Suggestion _$SuggestionFromJson(Map<String, dynamic> json) {
  return Suggestion(
      json['comf'] == null
          ? null
          : Suggest.fromJson(json['comf'] as Map<String, dynamic>),
      json['sport'] == null
          ? null
          : Suggest.fromJson(json['sport'] as Map<String, dynamic>),
      json['cw'] == null
          ? null
          : Suggest.fromJson(json['cw'] as Map<String, dynamic>));
}

Map<String, dynamic> _$SuggestionToJson(Suggestion instance) =>
    <String, dynamic>{
      'comf': instance.comf,
      'sport': instance.sport,
      'cw': instance.cw
    };

Suggest _$SuggestFromJson(Map<String, dynamic> json) {
  return Suggest(
      json['type'] as String, json['brf'] as String, json['txt'] as String);
}

Map<String, dynamic> _$SuggestToJson(Suggest instance) => <String, dynamic>{
      'type': instance.type,
      'brf': instance.brf,
      'txt': instance.txt
    };
