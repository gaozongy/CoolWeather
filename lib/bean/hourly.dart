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
}

class StringValue{
  String value;
  String datetime;
}

class IntValue{
  int value;
  String datetime;
}

class DoubleValue{
  double value;
  String datetime;
}

class Wind{
  double direction;
  double speed;
  String datetime;
}

