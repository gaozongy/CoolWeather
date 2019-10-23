/// 彩云天气接口参数转文字描述
class Translation {
  /// 天气代码转文字 雷达降水强度（0 ~ 1）判断降水等级：0.03~0.25 小雨(雪)，  中雨(雪)， 大雨(雪)，  暴雨(雪)；
  static String getWeatherDesc(String weather, double intensity) {
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
        desc = getIntensityDesc(intensity) + '雨';
        break;
      case 'SNOW':
        desc = getIntensityDesc(intensity) + '雪';
        break;
      default:
        desc = '未知';
        break;
    }
    return desc;
  }

  static String getIntensityDesc(double intensity) {
    String desc;
    if (0.03 < intensity && intensity < 0.25) {
      desc = '小';
    } else if (0.25 < intensity && intensity < 0.35) {
      desc = '中';
    } else if (0.35 < intensity && intensity < 0.48) {
      desc = '大';
    } else if (0.48 < intensity) {
      desc = '暴';
    } else {
      desc = '';
    }
    return desc;
  }

  /// AQI值转空气质量描述
  static String getAqiDesc(int aqi) {
    if (aqi <= 50) {
      return '优';
    } else if (50 < aqi && aqi <= 100) {
      return '良';
    } else if (100 < aqi && aqi <= 150) {
      return '轻度污染';
    } else if (150 < aqi && aqi <= 200) {
      return '中度污染';
    } else if (200 < aqi && aqi <= 300) {
      return '重度污染';
    } else if (300 < aqi) {
      return '严重污染';
    }
    return '';
  }

  static String getWindDir(double angle) {
    if (337.5 < angle || angle < 22.5) {
      return '北风';
    } else if (22.5 <= angle && angle <= 67.5) {
      return '东北风';
    } else if (67.5 < angle && angle < 112.5) {
      return '东风';
    } else if (112.5 <= angle && angle <= 157.5) {
      return '东南风';
    } else if (157.5 < angle && angle < 202.5) {
      return '南风';
    } else if (202.5 <= angle && angle <= 247.5) {
      return '西南风';
    } else if (247.5 < angle && angle < 292.5) {
      return '西风';
    } else if (292.5 < angle && angle < 337.5) {
      return '东北风';
    }

    return '';
  }
}
