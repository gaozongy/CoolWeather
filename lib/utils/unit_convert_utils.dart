class UnitConvertUtils {
  /// 摄氏度 转 华氏度
  static double celsiusToFahrenheit(double celsius) {
    return celsius * 1.8 + 32;
  }

  /// 千米/小时 转 米/秒
  static double kmhToMs(double speed) {
    return speed * 1000 / 60 / 60;
  }

  /// 千米/小时 转 英尺/秒
  static double kmhToFts(double speed) {
    return speed * 3280.8399 / 60 / 60;
  }

  /// 千米/小时 转 英里/小时
  static double kmhToMph(double speed) {
    return speed * 0.621371192;
  }

  /// 千米/小时 转 海里/小时
  static double kmhToKts(double speed) {
    return speed * 0.539956803;
  }

  /// 千米 转 英里
  static double kmToMi(double distance) {
    return distance * 0.621371192;
  }

  /// 帕 转 百帕
  static double paToHpa(double pres) {
    return pres / 100;
  }

  /// 帕 转 毫米汞柱
  static double paToMmHg(double pres) {
    return pres / 133.28;
  }

  /// 帕 转 英寸汞柱
  static double paToInHg(double pres) {
    return pres / 133.28 * 0.0393700787;
  }
}
