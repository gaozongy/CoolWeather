package www.gl.com.coolweather.widget;

import android.app.PendingIntent;
import android.content.Context;
import android.widget.RemoteViews;

import java.util.Calendar;
import java.util.Date;

import www.gl.com.coolweather.R;
import www.gl.com.coolweather.bean.Daily;
import www.gl.com.coolweather.bean.Realtime;
import www.gl.com.coolweather.bean.Result;
import www.gl.com.coolweather.bean.Skycon;
import www.gl.com.coolweather.bean.Temperature;
import www.gl.com.coolweather.bean.WeatherBean;
import www.gl.com.coolweather.utils.DateUtils;
import www.gl.com.coolweather.utils.ImageUtils;
import www.gl.com.coolweather.utils.TranslationUtils;

/**
 * 标准 Widget
 */
public class AppWidget extends BaseAppWidget {

    @Override
    protected int layoutId() {
        return R.layout.app_widget;
    }

    @Override
    protected void noLocation(Context context, RemoteViews remoteViews, String district, WeatherBean weatherBean) {
        // 打开APP首页的Intent
        PendingIntent launchPendingIntent = createLaunchPendingIntent(context);
        // 刷新的Intent
        PendingIntent updatePendingIntent = createUpdatePendingIntent(context);

        remoteViews.setTextViewText(R.id.widget_district_tv, district);
        remoteViews.setTextViewText(R.id.widget_update_time_tv, context.getString(R.string.widget_unknown));
        remoteViews.setOnClickPendingIntent(R.id.widget_rl, launchPendingIntent);
        remoteViews.setOnClickPendingIntent(R.id.widget_update_fl, updatePendingIntent);

        RemoteViews animViewDefault = new RemoteViews(context.getPackageName(), R.layout.app_widget_anim_view_default);
        remoteViews.removeAllViews(R.id.widget_update_anim_fl);
        remoteViews.addView(R.id.widget_update_anim_fl, animViewDefault);
    }

    @Override
    protected void updating(Context context, RemoteViews remoteViews, String district, WeatherBean weatherBean) {
        // 打开APP首页的Intent
        PendingIntent launchPendingIntent = createLaunchPendingIntent(context);
        remoteViews.setTextViewText(R.id.widget_update_time_tv, context.getString(R.string.widget_updating));
        remoteViews.setOnClickPendingIntent(R.id.widget_rl, launchPendingIntent);

        RemoteViews animView = new RemoteViews(context.getPackageName(), R.layout.app_widget_anim_view);
        remoteViews.removeAllViews(R.id.widget_update_anim_fl);
        remoteViews.addView(R.id.widget_update_anim_fl, animView);
    }

    @Override
    protected void updateSuccess(Context context, RemoteViews remoteViews, String district, WeatherBean weatherBean) {
        // 打开APP首页的Intent
        PendingIntent launchPendingIntent = createLaunchPendingIntent(context);
        // 刷新的Intent
        PendingIntent updatePendingIntent = createUpdatePendingIntent(context);

        showAppWidgetData(context, remoteViews, district, weatherBean);
        remoteViews.setOnClickPendingIntent(R.id.widget_rl, launchPendingIntent);
        remoteViews.setOnClickPendingIntent(R.id.widget_update_fl, updatePendingIntent);

        RemoteViews animViewDefault = new RemoteViews(context.getPackageName(), R.layout.app_widget_anim_view_default);
        remoteViews.removeAllViews(R.id.widget_update_anim_fl);
        remoteViews.addView(R.id.widget_update_anim_fl, animViewDefault);
    }

    @Override
    protected void updateFail(Context context, RemoteViews remoteViews, String district, WeatherBean weatherBean) {
        // 打开APP首页的Intent
        PendingIntent launchPendingIntent = createLaunchPendingIntent(context);
        // 刷新的Intent
        PendingIntent updatePendingIntent = createUpdatePendingIntent(context);

        remoteViews.setTextViewText(R.id.widget_update_time_tv, context.getString(R.string.widget_update_failed));
        remoteViews.setOnClickPendingIntent(R.id.widget_rl, launchPendingIntent);
        remoteViews.setOnClickPendingIntent(R.id.widget_update_fl, updatePendingIntent);

        RemoteViews animViewDefault = new RemoteViews(context.getPackageName(), R.layout.app_widget_anim_view_default);
        remoteViews.removeAllViews(R.id.widget_update_anim_fl);
        remoteViews.addView(R.id.widget_update_anim_fl, animViewDefault);
    }

    private void showAppWidgetData(Context context, RemoteViews remoteViews, String district, WeatherBean weatherBean) {
        Realtime realtime = weatherBean.result.realtime;
        Daily daily = weatherBean.result.daily;

        remoteViews.setTextViewText(R.id.widget_district_tv, district);
        remoteViews.setTextViewText(R.id.widget_weather_tv, TranslationUtils.getWeatherDesc(realtime.skycon, realtime.precipitation.local.intensity));
        remoteViews.setTextViewText(R.id.widget_temperature_tv, (int)realtime.temperature + "°");

        String updateDate = DateUtils.getFormatDate(weatherBean.server_time * 1000, DateUtils.HHmm);
        remoteViews.setTextViewText(R.id.widget_update_time_tv, context.getString(R.string.widget_update_time, updateDate));

        remoteViews.setTextViewText(R.id.widget_max_min_tv, (int)daily.temperature.get(0).max
                + " / " + (int)daily.temperature.get(0).min + "°");

        // 明天预报
        Skycon skycon1 = daily.skycon.get(1);
        Temperature temperature1 = daily.temperature.get(1);
        remoteViews.setTextViewText(R.id.widget_forecast_day_1_tv, context.getString(R.string.widget_tomorrow));
        remoteViews.setImageViewResource(R.id.widget_forecast_icon_1_iv, ImageUtils.getWeatherIcon(skycon1.value));
        remoteViews.setTextViewText(R.id.widget_forecast_temperature_1_iv, (int)temperature1.max
                + " / " + (int)temperature1.min + "°");

        Calendar calendar = Calendar.getInstance();

        // 后天预报
        Skycon skycon2 = daily.skycon.get(2);
        Date date2 = DateUtils.getDate(skycon2.date, DateUtils.yyyyMMdd);
        Temperature temperature2 = daily.temperature.get(2);
        if (date2 != null) {
            calendar.setTime(date2);
            remoteViews.setTextViewText(R.id.widget_forecast_day_2_tv, DateUtils.getWeekday(
                    calendar.get(Calendar.DAY_OF_WEEK) - 1));
            remoteViews.setImageViewResource(R.id.widget_forecast_icon_2_iv, ImageUtils.getWeatherIcon(skycon2.value));
            remoteViews.setTextViewText(R.id.widget_forecast_temperature_2_iv, (int)temperature2.max
                    + " / " + (int)temperature2.min + "°");
        }

        // 大后天预报
        Skycon skycon3 = daily.skycon.get(3);
        Date date3 = DateUtils.getDate(skycon3.date, DateUtils.yyyyMMdd);
        Temperature temperature3 = daily.temperature.get(3);
        if (date3 != null) {
            calendar.setTime(date3);
            remoteViews.setTextViewText(R.id.widget_forecast_day_3_tv, DateUtils.getWeekday(calendar.get(
                    Calendar.DAY_OF_WEEK) - 1));
            remoteViews.setImageViewResource(R.id.widget_forecast_icon_3_iv, ImageUtils.getWeatherIcon(skycon3.value));
            remoteViews.setTextViewText(R.id.widget_forecast_temperature_3_iv, (int)temperature3.max
                    + " / " + (int)temperature3.min + "°");
        }

        // 天气描述
        String weather = weatherBean.result.realtime.skycon;
        // 降雨（雪）强度
        double intensity = weatherBean.result.realtime.precipitation.local.intensity;
        // 是否是白天
        Result result = weatherBean.result;
        String currentDate = DateUtils.getFormatDate(new Date(), DateUtils.yyyyMMdd) + " ";
        Date sunriseDate = DateUtils.getDate(currentDate + result.daily.astro.get(0).sunrise.time, DateUtils.yyyyMMddHHmm);
        Date sunsetDate = DateUtils.getDate(currentDate + result.daily.astro.get(0).sunset.time, DateUtils.yyyyMMddHHmm);
        Date date = new Date();
        boolean isDay = date.compareTo(sunriseDate) >= 0 && date.compareTo(sunsetDate) < 0;

        // 设置背景
        remoteViews.setInt(R.id.widget_rl, "setBackgroundResource", ImageUtils.getBgResourceId(weather, intensity, isDay));
    }
}

// 获取 Flutter SharedPreferences 插件存储的值
// SharedPreferences sharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
// String locationDistrictBean = sharedPreferences.getString("flutter.location_district", "");