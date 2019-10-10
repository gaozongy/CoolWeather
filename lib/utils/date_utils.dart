/// 时间工具类
class DateUtils {
  static String getWeekday(int weekday) {
    String desc = '';
    switch (weekday) {
      case 1:
        {
          desc = '周一';
        }
        break;
      case 2:
        {
          desc = '周二';
        }
        break;
      case 3:
        {
          desc = '周三';
        }
        break;
      case 4:
        {
          desc = '周四';
        }
        break;
      case 5:
        {
          desc = '周五';
        }
        break;
      case 6:
        {
          desc += '周六';
        }
        break;
      case 7:
        {
          desc = '周日';
        }
        break;
      default:
        {}
    }

    DateTime dateTime = DateTime.now();
    if (dateTime.weekday == weekday) {
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
