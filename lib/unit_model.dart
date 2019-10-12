import 'package:flutter/material.dart';

class UnitModel with ChangeNotifier {
  String _tempUnit = 'haha';
  String _windUnit;
  String _rainfallUnit;
  String _visibilityUnit;
  String _airPressureUnit;

  UnitModel();

  void add() {
    notifyListeners();
  }

  get tempUnit => _tempUnit;
}