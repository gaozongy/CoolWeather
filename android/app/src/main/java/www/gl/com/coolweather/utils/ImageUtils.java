package www.gl.com.coolweather.utils;

import www.gl.com.coolweather.R;

public class ImageUtils {
    public static int getWeatherIcon(String weather) {
        int iconId;
        switch (weather) {
            case "CLEAR_DAY":
            case "CLEAR_NIGHT":
                iconId = R.drawable.ic_sunny;
                break;
            case "PARTLY_CLOUDY_DAY":
            case "PARTLY_CLOUDY_NIGHT":
                iconId = R.drawable.ic_cloud;
                break;
            case "CLOUDY":
                iconId = R.drawable.ic_nosun;
                break;
            case "WIND":
                iconId = R.drawable.ic_wind;
                break;
            case "HAZE":
                iconId = R.drawable.ic_haze;
                break;
            case "RAIN":
                iconId = R.drawable.ic_rain;
                break;
            case "SNOW":
                iconId = R.drawable.ic_snow;
                break;
            default:
                iconId = R.drawable.ic_sunny;
                break;
        }
        return iconId;
    }

    public static int getBgResourceId(String weather, double intensity, boolean isDay) {
        int bgResId;
        switch (weather) {
            case "CLEAR_DAY":
                bgResId = R.drawable.bg_widget_sunny;
                break;
            case "CLEAR_NIGHT":
                bgResId = R.drawable.bg_widget_sunny_night;
                break;
            case "PARTLY_CLOUDY_DAY":
                bgResId = R.drawable.bg_widget_cloudy;
                break;
            case "PARTLY_CLOUDY_NIGHT":
                bgResId = R.drawable.bg_widget_cloudy_night;
                break;
            case "CLOUDY":
                bgResId = isDay ? R.drawable.bg_widget_overcast : R.drawable.bg_widget_overcast_night;
                break;
            case "WIND":
                bgResId = isDay ? R.drawable.bg_widget_sunny : R.drawable.bg_widget_sunny_night;
                break;
            case "HAZE":
                bgResId = isDay ? R.drawable.bg_widget_haze : R.drawable.bg_widget_haze_night;
                break;
            case "RAIN":
                if (0.03 < intensity && intensity < 0.25) {
                    bgResId = isDay ? R.drawable.bg_widget_drizzle : R.drawable.bg_widget_drizzle_night;
                } else if (0.25 < intensity && intensity < 0.35) {
                    bgResId = isDay ? R.drawable.bg_widget_rain : R.drawable.bg_widget_rain_night;
                } else if (0.35 < intensity && intensity < 0.48) {
                    bgResId = isDay ? R.drawable.bg_widget_downpour : R.drawable.bg_widget_downpour_night;
                } else if (0.48 < intensity) {
                    bgResId = isDay ? R.drawable.bg_widget_rainstorm : R.drawable.bg_widget_rainstorm_night;
                } else {
                    bgResId = isDay ? R.drawable.bg_widget_rain : R.drawable.bg_widget_rain_night;
                }
                break;
            case "SNOW":
                if (0.03 < intensity && intensity < 0.25) {
                    bgResId = isDay ? R.drawable.bg_widget_snow : R.drawable.bg_widget_snow_night;
                } else if (0.25 < intensity && intensity < 0.35) {
                    bgResId = isDay ? R.drawable.bg_widget_snow : R.drawable.bg_widget_snow_night;
                } else if (0.35 < intensity && intensity < 0.48) {
                    bgResId = isDay ? R.drawable.bg_widget_snow : R.drawable.bg_widget_snow_night;
                } else if (0.48 < intensity) {
                    bgResId = isDay ? R.drawable.bg_widget_snow : R.drawable.bg_widget_snow_night;
                } else {
                    bgResId = isDay ? R.drawable.bg_widget_snow : R.drawable.bg_widget_snow_night;
                }
                break;
            default:
                bgResId = R.drawable.bg_widget_sunny;
                break;
        }
        return bgResId;
    }

    public static int getRoundBgResourceId(String weather, double intensity, boolean isDay) {
        int bgResId;
        switch (weather) {
            case "CLEAR_DAY":
                bgResId = R.drawable.bg_widget_round_sunny;
                break;
            case "CLEAR_NIGHT":
                bgResId = R.drawable.bg_widget_round_sunny_night;
                break;
            case "PARTLY_CLOUDY_DAY":
                bgResId = R.drawable.bg_widget_round_cloudy;
                break;
            case "PARTLY_CLOUDY_NIGHT":
                bgResId = R.drawable.bg_widget_round_cloudy_night;
                break;
            case "CLOUDY":
                bgResId = isDay ? R.drawable.bg_widget_round_overcast : R.drawable.bg_widget_round_overcast_night;
                break;
            case "WIND":
                bgResId = isDay ? R.drawable.bg_widget_round_sunny : R.drawable.bg_widget_round_sunny_night;
                break;
            case "HAZE":
                bgResId = isDay ? R.drawable.bg_widget_round_haze : R.drawable.bg_widget_round_haze_night;
                break;
            case "RAIN":
                if (0.03 < intensity && intensity < 0.25) {
                    bgResId = isDay ? R.drawable.bg_widget_round_drizzle : R.drawable.bg_widget_round_drizzle_night;
                } else if (0.25 < intensity && intensity < 0.35) {
                    bgResId = isDay ? R.drawable.bg_widget_round_rain : R.drawable.bg_widget_round_rain_night;
                } else if (0.35 < intensity && intensity < 0.48) {
                    bgResId = isDay ? R.drawable.bg_widget_round_downpour : R.drawable.bg_widget_round_downpour_night;
                } else if (0.48 < intensity) {
                    bgResId = isDay ? R.drawable.bg_widget_round_rainstorm : R.drawable.bg_widget_round_rainstorm_night;
                } else {
                    bgResId = isDay ? R.drawable.bg_widget_round_rain : R.drawable.bg_widget_round_rain_night;
                }
                break;
            case "SNOW":
                if (0.03 < intensity && intensity < 0.25) {
                    bgResId = isDay ? R.drawable.bg_widget_round_snow : R.drawable.bg_widget_round_snow_night;
                } else if (0.25 < intensity && intensity < 0.35) {
                    bgResId = isDay ? R.drawable.bg_widget_round_snow : R.drawable.bg_widget_round_snow_night;
                } else if (0.35 < intensity && intensity < 0.48) {
                    bgResId = isDay ? R.drawable.bg_widget_round_snow : R.drawable.bg_widget_round_snow_night;
                } else if (0.48 < intensity) {
                    bgResId = isDay ? R.drawable.bg_widget_round_snow : R.drawable.bg_widget_round_snow_night;
                } else {
                    bgResId = isDay ? R.drawable.bg_widget_round_snow : R.drawable.bg_widget_round_snow_night;
                }
                break;
            default:
                bgResId = R.drawable.bg_widget_round_sunny;
                break;
        }
        return bgResId;
    }
}
