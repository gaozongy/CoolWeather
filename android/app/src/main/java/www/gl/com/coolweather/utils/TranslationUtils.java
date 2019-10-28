package www.gl.com.coolweather.utils;

public class TranslationUtils {
   public static String getWeatherDesc(String weather, double intensity) {
        String desc = "";
        switch (weather) {
            case "CLEAR_DAY":
            case "CLEAR_NIGHT":
                desc = "晴朗";
                break;
            case "PARTLY_CLOUDY_DAY":
            case "PARTLY_CLOUDY_NIGHT":
                desc = "多云";
                break;
            case "CLOUDY":
                desc = "阴";
                break;
            case "WIND":
                desc = "大风";
                break;
            case "HAZE":
                desc = "雾霾";
                break;
            case "RAIN":
                if (0.03 < intensity && intensity < 0.25) {
                    desc = "小雨";
                } else if (0.25 < intensity && intensity < 0.35) {
                    desc = "中雨";
                } else if (0.35 < intensity && intensity < 0.48) {
                    desc = "大雨";
                } else if (0.48 < intensity) {
                    desc = "暴雨";
                }
                break;
            case "SNOW":
                if (0.03 < intensity && intensity < 0.25) {
                    desc = "小雪";
                } else if (0.25 < intensity && intensity < 0.35) {
                    desc = "中雪";
                } else if (0.35 < intensity && intensity < 0.48) {
                    desc = "大雪";
                } else if (0.48 < intensity) {
                    desc = "暴雪";
                }
                break;
            default:
                desc = "未知";
                break;
        }
        return desc;
    }
}
