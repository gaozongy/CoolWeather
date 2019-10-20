package www.gl.com.coolweather.utils;

public class DateUtils {

    public static String getWeekday(int weekday) {
        String[] week = {"周日", "周一", "周二", "周三", "周四", "周五", "周六"};
        return week[weekday];
    }
}
