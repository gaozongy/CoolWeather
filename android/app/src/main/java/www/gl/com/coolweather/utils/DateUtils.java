package www.gl.com.coolweather.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class DateUtils {

    public static final String HHmm = "HH:mm";

    public static final String yyyyMMdd = "yyyy-MM-dd";

    public static final String yyyyMMddHHmm = "yyyy-MM-dd HH:mm";

    public static String getWeekday(int weekday) {
        String[] week = {"周日", "周一", "周二", "周三", "周四", "周五", "周六"};
        return week[weekday];
    }

    public static String getFormatDate(long millisecond, String format) {
        return getFormatDate(new Date(millisecond), format);
    }

    public static String getFormatDate(Date date, String format) {
        SimpleDateFormat sdf = new SimpleDateFormat(format, Locale.CHINA);
        return sdf.format(date);
    }

    public static Date getDate(String date, String format) {
        SimpleDateFormat sdf = new SimpleDateFormat(format, Locale.CHINA);
        try {
            return sdf.parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return new Date();
    }
}
