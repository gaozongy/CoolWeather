import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 温度单位
enum TemperatureUnit {
  celsius,
  fahrenheit,
}

/// 风速单位
enum WindUnit { m_s, km_h, ft_s, mph, kts }

/// 降雨量单位
enum RainfallUnit { mm, in_ }

/// 能见度单位
enum VisibilityUnit { km, mi }

/// 气压单位
enum AirPressureUnit { hPa, mmHg, inHg }

class Unit {
  String unitEN;
  String unitCN;
  String unitShow;

  Unit(this.unitEN, this.unitCN, {this.unitShow});

  String toString() {
    return unitEN + " - " + unitCN;
  }
}

List<Unit> temperatureUnitList = [
  Unit('℃', '摄氏度', unitShow: '°'),
  Unit('℉', '华氏度', unitShow: '°')
];

List<Unit> windUnitList = [
  Unit('m/s', '米/秒'),
  Unit('km/h ', ' 千米/小时'),
  Unit('ft/s ', ' 英尺/秒'),
  Unit('mph ', ' 英里/小时'),
  Unit('kts ', ' 海里/小时')
];

List<Unit> rainfallUnitList = [
  Unit('mm ', ' 毫米'),
  Unit('in ', ' 英寸'),
];

List<Unit> visibilityUnitList = [
  Unit('km ', ' 千米'),
  Unit('mi ', ' 英里'),
];

List<Unit> airPressureUnitList = [
  Unit('hPa ', ' 百帕'),
  Unit('mmHg ', ' 毫米汞柱'),
  Unit('inHg ', ' 英寸汞柱'),
];

String temperatureUnitKey = 'temperatureUnitKey';
String windUnitKey = 'windUnitKey';
String rainfallUnitKey = 'rainfallUnitKey';
String visibilityUnitKey = 'visibilityUnitKey';
String airPressureUnitKey = 'airPressureUnitKey';

class UnitModel with ChangeNotifier {
  TemperatureUnit temperature = TemperatureUnit.celsius;
  WindUnit wind = WindUnit.km_h;
  RainfallUnit rainfall = RainfallUnit.mm;
  VisibilityUnit visibility = VisibilityUnit.km;
  AirPressureUnit airPressure = AirPressureUnit.hPa;

  void setTemperatureUnit(int index) {
    temperature = TemperatureUnit.values[index];
    notifyListeners();
    saveUnit(temperatureUnitKey, index);
  }

  void setWindUnit(int index) {
    wind = WindUnit.values[index];
    notifyListeners();
    saveUnit(windUnitKey, index);
  }

  void setRainfallUnit(int index) {
    rainfall = RainfallUnit.values[index];
    notifyListeners();
    saveUnit(rainfallUnitKey, index);
  }

  void setVisibilityUnit(int index) {
    visibility = VisibilityUnit.values[index];
    notifyListeners();
    saveUnit(visibilityUnitKey, index);
  }

  void setAirPressureUnit(int index) {
    airPressure = AirPressureUnit.values[index];
    notifyListeners();
    saveUnit(airPressureUnitKey, index);
  }

  void saveUnit(String key, int value) {
    Future<SharedPreferences> future = SharedPreferences.getInstance();
    future.then((prefs) {
      prefs.setInt(key, value);
    });
  }

  void initUnit() {
    Future<SharedPreferences> future = SharedPreferences.getInstance();
    future.then((prefs) {
      temperature = TemperatureUnit.values[prefs.getInt(temperatureUnitKey)];
      wind = WindUnit.values[prefs.getInt(windUnitKey)];
      rainfall = RainfallUnit.values[prefs.getInt(rainfallUnitKey)];
      visibility = VisibilityUnit.values[prefs.getInt(visibilityUnitKey)];
      airPressure = AirPressureUnit.values[prefs.getInt(airPressureUnitKey)];
    });
  }
}