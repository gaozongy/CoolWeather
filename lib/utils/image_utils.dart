class ImageUtils {
  static String getIconUriByWeather(String weather) {
    String weatherIcon;
    switch (weather) {
      case 'CLEAR_DAY':
      case 'CLEAR_NIGHT':
        {
          weatherIcon = 'images/ic_weather/ic_sunny.png';
        }
        break;
      case 'PARTLY_CLOUDY_DAY':
      case 'PARTLY_CLOUDY_NIGHT':
        {
          weatherIcon = 'images/ic_weather/ic_cloud.png';
        }
        break;
      case 'CLOUDY':
        {
          weatherIcon = 'images/ic_weather/ic_nosun.png';
        }
        break;
      case 'WIND':
        {
          weatherIcon = 'images/ic_weather/ic_wind.png';
        }
        break;
      case 'HAZE':
        {
          weatherIcon = 'images/ic_weather/ic_haze.png';
        }
        break;
      case 'RAIN':
        {
          weatherIcon = 'images/ic_weather/ic_rain.png';
        }
        break;
      case 'SNOW':
        {
          weatherIcon = 'images/ic_weather/ic_snow.png';
        }
        break;
      default:
        break;
    }

    return weatherIcon;
  }
}
