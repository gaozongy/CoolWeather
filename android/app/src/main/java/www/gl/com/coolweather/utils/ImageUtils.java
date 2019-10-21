package www.gl.com.coolweather.utils;

import java.util.Date;

import www.gl.com.coolweather.R;
import www.gl.com.coolweather.bean.Result;
import www.gl.com.coolweather.bean.WeatherBean;

public class ImageUtils {
    public static int getWeatherIcon(String weather) {
        int iconId;
        switch (weather) {
            case "CLEAR_DAY":
            case "CLEAR_NIGHT":
                iconId = R.drawable.sunny_ic;
                break;
            case "PARTLY_CLOUDY_DAY":
            case "PARTLY_CLOUDY_NIGHT":
                iconId = R.drawable.cloud_ic;
                break;
            case "CLOUDY":
                iconId = R.drawable.nosun_ic;
                break;
            case "WIND":
                iconId = R.drawable.wind_ic;
                break;
            case "HAZE":
                iconId = R.drawable.haze_ic;
                break;
            case "RAIN":
                iconId = R.drawable.rain_ic;
                break;
            case "SNOW":
                iconId = R.drawable.snow_ic;
                break;
            default:
                iconId = R.drawable.sunny_ic;
                break;
        }
        return iconId;
    }

    public static int getBgResourceId(WeatherBean weatherBean) {
        int bgResId;
        Result result = weatherBean.result;
        String currentDate = DateUtils.getFormatDate(new Date(), DateUtils.yyyyMMdd) + " ";
        Date sunriseDate = DateUtils.getDate(currentDate + result.daily.astro.get(0).sunrise.time, DateUtils.yyyyMMddHHmm);
        Date sunsetDate = DateUtils.getDate(currentDate + result.daily.astro.get(0).sunset.time, DateUtils.yyyyMMddHHmm);
        Date date = new Date();
        boolean isDay = date.compareTo(sunriseDate) > 0 && date.compareTo(sunsetDate) < 0;
        String weather = weatherBean.result.realtime.skycon;
        switch (weather) {
            case "CLEAR_DAY":
                bgResId = R.drawable.bkg_sunny_widget;
                break;
            case "CLEAR_NIGHT":
                bgResId = R.drawable.bkg_sunny_night_widget;
                break;
            case "PARTLY_CLOUDY_DAY":
                bgResId = R.drawable.bkg_cloudy_widget;
                break;
            case "PARTLY_CLOUDY_NIGHT":
                bgResId = R.drawable.bkg_cloudy_night_widget;
                break;
            case "CLOUDY":
                bgResId = isDay ? R.drawable.bkg_overcast_widget : R.drawable.bkg_overcast_night_widget;
                break;
            case "WIND":
                bgResId = isDay ? R.drawable.bkg_sunny_widget : R.drawable.bkg_sunny_night_widget;
                break;
            case "HAZE":
                bgResId = isDay ? R.drawable.bkg_haze_widget : R.drawable.bkg_haze_night_widget;
                break;
            case "RAIN":
                bgResId = isDay ? R.drawable.bkg_downpour_widget : R.drawable.bkg_downpour_night_widget;
                break;
            case "SNOW":
                bgResId = isDay ? R.drawable.bkg_snow_widget : R.drawable.bkg_snow_night_widget;
                break;
            default:
                bgResId = R.drawable.bkg_sunny_widget;
                break;
        }
        return bgResId;
    }
}
