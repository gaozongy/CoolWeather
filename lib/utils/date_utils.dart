import 'package:coolweather/bean/weather_bean.dart';

/// 时间工具类
class DateUtils {
  static String getCurrentTimeMMDD() {
    DateTime dateTime = DateTime.now();
    return "${dateTime.month.toString().padLeft(2, '0')}月${dateTime.day.toString().padLeft(2, '0')}日";
  }

  static String getFormatTimeHHmm(String date) {
    DateTime dateTime = DateTime.parse(date);
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  static String getWeek(int weekday) {
    List<String> week = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    String desc = week.elementAt(weekday);
    return desc;
  }

  static String getWhichDay(int weekday, {bool todayWeek}) {
    List<String> week = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    String desc = week.elementAt(weekday);
    DateTime dateTime = DateTime.now();
    if ((todayWeek == null || todayWeek) && dateTime.weekday - 1 == weekday) {
      desc = '今天';
    }
    return desc;
  }

  static bool isDay(WeatherBean weatherBean) {
    DateTime date = DateTime.now();
    String currentDate =
        "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ";
    DateTime sunriseDate = DateTime.parse(currentDate +
        weatherBean.result.daily.astro.elementAt(0).sunrise.time);
    DateTime sunsetDate = DateTime.parse(currentDate +
        weatherBean.result.daily.astro.elementAt(0).sunset.time);
    return isDayLocaL(sunriseDate, sunsetDate);
  }

  /// 是否是白天
  static bool isDayLocaL(DateTime sunriseDate, DateTime sunsetDate) {
    DateTime date = DateTime.now();
    return date.compareTo(sunriseDate) >= 0 && date.compareTo(sunsetDate) < 0;
  }

  static int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  static String getTimeDesc(int time) {
    int fiveMinute = 60 * 1000 * 5;
    int tenMinute = 60 * 1000 * 10;

    int currentTime = currentTimeMillis();
    time = time * 1000;
    int diff = currentTime - time;
    if (diff <= fiveMinute) {
      return '刚刚';
    } else if (fiveMinute < diff && diff <= tenMinute) {
      return '五分钟之前';
    }
    DateTime date = DateTime.fromMillisecondsSinceEpoch(time);
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
