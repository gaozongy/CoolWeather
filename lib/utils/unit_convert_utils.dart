class UnitConvertUtils {
  static double celsiusToFahrenheit(double celsius) {
    return celsius * 1.8 + 32;
  }

  static double kmhToMs(double speed) {
    return speed * 1000 / 60 / 60;
  }

  static double kmhToFts(double speed) {
    return speed * 3280.8399 / 60 / 60;
  }

  static double kmhToMph(double speed) {
    return speed * 0.621371192;
  }

  static double kmhToKts(double speed) {
    return speed * 0.539956803;
  }

  static double kmToMi(double distance) {
    return distance * 0.621371192;
  }

  static double paToHpa(double pres) {
    return pres / 100;
  }

  static double paToMmHg(double pres) {
    return pres / 133.28;
  }

  static double paToInHg(double pres) {
    return pres / 133.28 * 0.0393700787;
  }
}
