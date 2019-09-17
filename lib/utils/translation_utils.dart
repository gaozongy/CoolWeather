class Translation {
  static String getWeatherDesc(String weather) {
    String desc;
    switch (weather) {
      case 'CLEAR_DAY':
      case 'CLEAR_NIGHT':
        desc = '晴朗';
        break;
      case 'PARTLY_CLOUDY_DAY':
      case 'PARTLY_CLOUDY_NIGHT':
        desc = '多云';
        break;
      case 'CLOUDY':
        desc = '阴';
        break;
      case 'WIND':
        desc = '大风';
        break;
      case 'HAZE':
        desc = '雾霾';
        break;
      case 'RAIN':
        desc = '雨';
        break;
      case 'SNOW':
        desc = '雪';
        break;
      default:
        desc = '未知';
        break;
    }

    return desc;
  }
}
