package www.gl.com.coolweather.bean;

import java.util.List;

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
    List<WindHourly> wind;
    List<DoubleValue> temperature;
}

