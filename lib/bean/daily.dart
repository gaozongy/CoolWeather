class Daily {
  String status;
  List<Comfort> comfort;
  List<Skycon_20h_32h> skycon_20h_32h;
  List<Temperature> temperature;
  List<Dswrf> dswrf;
  List<Cloudrate> cloudrate;
  List<Aqi> aqi;
  List<Skycon> skycon;
  List<Visibility> visibility;
  List<Humidity> humidity;
  List<Astro> astro;
  List<ColdRisk> coldRisk;
  List<Ultraviolet> ultraviolet;
  List<Pm25> pm25;
  List<Dressing> dressing;
  List<CarWashing> carWashing;
  List<Precipitation> precipitation;
  List<Wind> wind;
  List<Skycon_08h_20h> skycon_08h_20h;
}

class Comfort {
  String index;
  String desc;
  String datetime;
}

class Skycon_20h_32h {
  String date;
  String value;
}

class Temperature {
  String date;
  double max;
  double avg;
  double min;
}

class Dswrf {
  String date;
  double max;
  double avg;
  double min;
}

class Cloudrate {
  String date;
  double max;
  double avg;
  double min;
}

class Aqi {
  String date;
  int max;
  double avg;
  int min;
}

class Skycon {
  String date;
  String value;
}

class Visibility {
  String date;
  double max;
  double avg;
  double min;
}

class Humidity {
  String date;
  double max;
  double avg;
  double min;
}

class Astro {
  String date;
  Sunset sunset;
  Sunrise sunrise;
}

class Sunset {
  String time;
}

class Sunrise {
  String time;
}

class ColdRisk {
  String index;
  String desc;
  String datetime;
}

class Ultraviolet {
  String index;
  String desc;
  String datetime;
}

class Pres {
  String date;
  double max;
  double avg;
  double min;
}

class Pm25 {
  String date;
  int max;
  double avg;
  int min;
}

class Dressing {
  String index;
  String desc;
  String datetime;
}

class CarWashing {
  String index;
  String desc;
  String datetime;
}

class Precipitation {
  String date;
  double max;
  double avg;
  double min;
}

class Wind {
  String date;
  WindValue max;
  WindValue avg;
  WindValue min;
}

class WindValue {
  double direction;
  double speed;
}

class Skycon_08h_20h {
  String date;
  String value;
}