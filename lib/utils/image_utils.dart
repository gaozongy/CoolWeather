class ImageUtils {
  static String getWeatherIconUri(String weather) {
    String weatherIcon;
    switch (weather) {
      case 'CLEAR_DAY':
        weatherIcon = 'images/ic_weather/ic_sunny.png';
        break;
      case 'CLEAR_NIGHT':
        weatherIcon = 'images/ic_weather/ic_sunny_night.png';
        break;
      case 'PARTLY_CLOUDY_DAY':
      case 'PARTLY_CLOUDY_NIGHT':
        weatherIcon = 'images/ic_weather/ic_cloud.png';
        break;
      case 'CLOUDY':
        weatherIcon = 'images/ic_weather/ic_nosun.png';
        break;
      case 'WIND':
        weatherIcon = 'images/ic_weather/ic_wind.png';
        break;
      case 'HAZE':
        weatherIcon = 'images/ic_weather/ic_haze.png';
        break;
      case 'RAIN':
        weatherIcon = 'images/ic_weather/ic_rain.png';
        break;
      case 'SNOW':
        weatherIcon = 'images/ic_weather/ic_snow.png';
        break;
      case 'SUNRISE':
        weatherIcon = 'images/ic_weather/ic_sunrise.png';
        break;
      case 'SUNSET':
        weatherIcon = 'images/ic_weather/ic_sunset.png';
        break;
      default:
        weatherIcon = 'images/ic_weather/ic_sunny.png';
        break;
    }

    return weatherIcon;
  }

  static String getWeatherBgUri(String weather, double intensity, bool isDay) {
    String bgResource;
    switch (weather) {
      case "CLEAR_DAY":
        bgResource = 'images/bg_weather/bg_sunny.png';
        break;
      case "CLEAR_NIGHT":
        bgResource = 'images/bg_weather/bg_sunny_night.png';
        break;
      case "PARTLY_CLOUDY_DAY":
        bgResource = 'images/bg_weather/bg_cloudy.png';
        break;
      case "PARTLY_CLOUDY_NIGHT":
        bgResource = 'images/bg_weather/bg_cloudy_night.png';
        break;
      case "CLOUDY":
        bgResource = isDay
            ? 'images/bg_weather/bg_overcast.png'
            : 'images/bg_weather/bg_overcast_night.png';
        break;
      case "WIND":
        bgResource = isDay
            ? 'images/bg_weather/bg_sunny.png'
            : 'images/bg_weather/bg_sunny_night.png';
        break;
      case "HAZE":
        bgResource = isDay
            ? 'images/bg_weather/bg_haze.png'
            : 'images/bg_weather/bg_haze_night.png';
        break;
      case "RAIN":
        if (0.03 < intensity && intensity <= 0.25) {
          bgResource = isDay
              ? 'images/bg_weather/bg_drizzle.png'
              : 'images/bg_weather/bg_drizzle_night.png';
        } else if (0.25 < intensity && intensity <= 0.35) {
          bgResource = isDay
              ? 'images/bg_weather/bg_rain.png'
              : 'images/bg_weather/bg_rain_night.png';
        } else if (0.35 < intensity && intensity <= 0.48) {
          bgResource = isDay
              ? 'images/bg_weather/bg_downpour.png'
              : 'images/bg_weather/bg_downpour_night.png';
        } else if (0.48 < intensity) {
          bgResource = isDay
              ? 'images/bg_weather/bg_rainstorm.png'
              : 'images/bg_weather/bg_rainstorm_night.png';
        } else {
          bgResource = isDay
              ? 'images/bg_weather/bg_downpour.png'
              : 'images/bg_weather/bg_downpour_night.png';
        }
        break;
      case "SNOW":
        if (0.03 < intensity && intensity <= 0.25) {
          bgResource = isDay
              ? 'images/bg_weather/bg_snow.png'
              : 'images/bg_weather/bg_snow_night.png';
        } else if (0.25 < intensity && intensity <= 0.35) {
          bgResource = isDay
              ? 'images/bg_weather/bg_snow.png'
              : 'images/bg_weather/bg_snow_night.png';
        } else if (0.35 < intensity && intensity <= 0.48) {
          bgResource = isDay
              ? 'images/bg_weather/bg_snow.png'
              : 'images/bg_weather/bg_snow_night.png';
        } else if (0.48 < intensity) {
          bgResource = isDay
              ? 'images/bg_weather/bg_snow.png'
              : 'images/bg_weather/bg_snow_night.png';
        } else {
          bgResource = isDay
              ? 'images/bg_weather/bg_snow.png'
              : 'images/bg_weather/bg_snow_night.png';
        }
        break;
      default:
        bgResource = 'images/bg_weather/bg_sunny.png';
        break;
    }
    return bgResource;
  }

  static String getWeatherShareBgUri(
      String weather, double intensity, bool isDay) {
    String bgResource;
    switch (weather) {
      case "CLEAR_DAY":
        bgResource = 'images/bg_share/bg_sunny_share.png';
        break;
      case "CLEAR_NIGHT":
        bgResource = 'images/bg_share/bg_sunny_night_share.png';
        break;
      case "PARTLY_CLOUDY_DAY":
        bgResource = 'images/bg_share/bg_cloudy_share.png';
        break;
      case "PARTLY_CLOUDY_NIGHT":
        bgResource = 'images/bg_share/bg_cloudy_night_share.png';
        break;
      case "CLOUDY":
        bgResource = isDay
            ? 'images/bg_share/bg_overcast_share.png'
            : 'images/bg_share/bg_overcast_night_share.png';
        break;
      case "WIND":
        bgResource = isDay
            ? 'images/bg_share/bg_sunny_share.png'
            : 'images/bg_share/bg_sunny_night_share.png';
        break;
      case "HAZE":
        bgResource = isDay
            ? 'images/bg_share/bg_haze_share.png'
            : 'images/bg_share/bg_haze_night_share.png';
        break;
      case "RAIN":
        if (0.03 < intensity && intensity < 0.25) {
          bgResource = isDay
              ? 'images/bg_share/bg_drizzle_share.png'
              : 'images/bg_share/bg_drizzle_night_share.png';
        } else if (0.25 < intensity && intensity < 0.35) {
          bgResource = isDay
              ? 'images/bg_share/bg_rain_share.png'
              : 'images/bg_share/bg_rain_night_share.png';
        } else if (0.35 < intensity && intensity < 0.48) {
          bgResource = isDay
              ? 'images/bg_share/bg_downpour_share.png'
              : 'images/bg_share/bg_downpour_night_share.png';
        } else if (0.48 < intensity) {
          bgResource = isDay
              ? 'images/bg_share/bg_rainstorm_share.png'
              : 'images/bg_share/bg_rainstorm_night_share.png';
        } else {
          bgResource = isDay
              ? 'images/bg_share/bg_downpour_share.png'
              : 'images/bg_share/bg_downpour_night_share.png';
        }
        break;
      case "SNOW":
        if (0.03 < intensity && intensity < 0.25) {
          bgResource = isDay
              ? 'images/bg_share/bg_snow_share.png'
              : 'images/bg_share/bg_snow_night_share.png';
        } else if (0.25 < intensity && intensity < 0.35) {
          bgResource = isDay
              ? 'images/bg_share/bg_snow_share.png'
              : 'images/bg_share/bg_snow_night_share.png';
        } else if (0.35 < intensity && intensity < 0.48) {
          bgResource = isDay
              ? 'images/bg_share/bg_snow_share.png'
              : 'images/bg_share/bg_snow_night_share.png';
        } else if (0.48 < intensity) {
          bgResource = isDay
              ? 'images/bg_share/bg_snow_share.png'
              : 'images/bg_share/bg_snow_night_share.png';
        } else {
          bgResource = isDay
              ? 'images/bg_share/bg_snow_share.png'
              : 'images/bg_share/bg_snow_night_share.png';
        }
        break;
      default:
        bgResource = 'images/bg_share/bg_sunny_share.png';
        break;
    }
    return bgResource;
  }
}
