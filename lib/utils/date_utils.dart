/// 时间工具类
class DateUtils {
  static String getWeekday(int weekday) {
    List<String> week = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    String desc = week.elementAt(weekday);
    DateTime dateTime = DateTime.now();
    if (dateTime.weekday== weekday) {
      desc = '今天';
    }
    return desc;
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
