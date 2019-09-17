class DateUtils {
  static String getWeekday(int weekday) {
    String desc = '周';
    switch (weekday) {
      case 1:
        {
          desc += '一';
        }
        break;
      case 2:
        {
          desc += '二';
        }
        break;
      case 3:
        {
          desc += '三';
        }
        break;
      case 4:
        {
          desc += '四';
        }
        break;
      case 5:
        {
          desc += '五';
        }
        break;
      case 6:
        {
          desc += '六';
        }
        break;
      case 7:
        {
          desc += '七';
        }
        break;
      default:
        {}
    }
    return desc;
  }
}
