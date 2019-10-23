package www.gl.com.coolweather.utils;

import www.gl.com.coolweather.R;

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

    public static int getBgResourceId(String weather, double intensity, boolean isDay) {
        int bgResId;
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
                if (0.03 < intensity && intensity < 0.25) {
                    bgResId = isDay ? R.drawable.bkg_drizzle_widget : R.drawable.bkg_drizzle_night_widget;
                } else if (0.25 < intensity && intensity < 0.35) {
                    bgResId = isDay ? R.drawable.bkg_rain_widget : R.drawable.bkg_rain_night_widget;
                } else if (0.35 < intensity && intensity < 0.48) {
                    bgResId = isDay ? R.drawable.bkg_downpour_widget : R.drawable.bkg_downpour_night_widget;
                } else if (0.48 < intensity) {
                    bgResId = isDay ? R.drawable.bkg_rainstorm_widget : R.drawable.bkg_rainstorm_night_widget;
                } else {
                    bgResId = isDay ? R.drawable.bkg_rain_widget : R.drawable.bkg_rain_night_widget;
                }
                break;
            case "SNOW":
                if (0.03 < intensity && intensity < 0.25) {
                    bgResId = isDay ? R.drawable.bkg_snow_widget : R.drawable.bkg_snow_night_widget;
                } else if (0.25 < intensity && intensity < 0.35) {
                    bgResId = isDay ? R.drawable.bkg_snow_widget : R.drawable.bkg_snow_night_widget;
                } else if (0.35 < intensity && intensity < 0.48) {
                    bgResId = isDay ? R.drawable.bkg_snow_widget : R.drawable.bkg_snow_night_widget;
                } else if (0.48 < intensity) {
                    bgResId = isDay ? R.drawable.bkg_snow_widget : R.drawable.bkg_snow_night_widget;
                } else {
                    bgResId = isDay ? R.drawable.bkg_snow_widget : R.drawable.bkg_snow_night_widget;
                }
                break;
            default:
                bgResId = R.drawable.bkg_sunny_widget;
                break;
        }
        return bgResId;
    }
}
