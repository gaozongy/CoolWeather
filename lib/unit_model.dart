import 'package:flutter/material.dart';

class UnitModel with ChangeNotifier {
  TemperatureUnit temperature = TemperatureUnit.celsius;
  WindUnit wind = WindUnit.km_h;
  RainfallUnit rainfall = RainfallUnit.mm;
  VisibilityUnit visibility = VisibilityUnit.km;
  AirPressureUnit airPressure = AirPressureUnit.hPa;

  void setTemperatureUnit(TemperatureUnit unit) {
    temperature = unit;
    notifyListeners();
  }
}

class Unit {
  String unit;
  Unit(this.unit);
}

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