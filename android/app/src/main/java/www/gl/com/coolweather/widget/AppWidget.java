package www.gl.com.coolweather.widget;

import android.Manifest;
import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.widget.RemoteViews;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;

import java.util.Calendar;
import java.util.Date;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import www.gl.com.coolweather.MainActivity;
import www.gl.com.coolweather.R;
import www.gl.com.coolweather.bean.Daily;
import www.gl.com.coolweather.bean.Realtime;
import www.gl.com.coolweather.bean.Result;
import www.gl.com.coolweather.bean.Skycon;
import www.gl.com.coolweather.bean.Temperature;
import www.gl.com.coolweather.bean.WeatherBean;
import www.gl.com.coolweather.net.ApiService;
import www.gl.com.coolweather.utils.DateUtils;
import www.gl.com.coolweather.utils.ImageUtils;
import www.gl.com.coolweather.utils.TranslationUtils;


public class AppWidget extends AppWidgetProvider {

    private static final String ACTION_UPDATE = "action_update";

    private final int NO_LOCATION = 0x01;

    private final int UPDATING = 0x02;

    private final int UPDATE_SUCCESS = 0x03;

    private final int UPDATE_FAIL = 0x04;

    @Override
    public void onReceive(final Context context, Intent intent) {
        super.onReceive(context, intent);

        String action = intent.getAction();
        if (ACTION_UPDATE.equals(action)) {
            getLocationData(context);
        }
    }

    @Override
    public void onUpdate(final Context context, final AppWidgetManager appWidgetManager, final int[] appWidgetIds) {
        getLocationData(context);
    }

    void getLocationData(Context context) {
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            updateAppWidget(NO_LOCATION, context, context.getString(R.string.widget_no_location_permission), null);
            return;
        }

        // 显示正在更新
        updateAppWidget(UPDATING, context, "", null);

        AMapLocationListener mLocationListener = aMapLocation -> {
            if (aMapLocation.getErrorCode() == 0) {
                String district = aMapLocation.getDistrict();
                double longitude = aMapLocation.getLongitude();
                double latitude = aMapLocation.getLatitude();
                getWeatherData(context, district, longitude, latitude);
            } else {
                updateAppWidget(NO_LOCATION, context, context.getString(R.string.widget_location_failed), null);
            }
        };

        AMapLocationClient locationClient = new AMapLocationClient(context);
        locationClient.setLocationListener(mLocationListener);
        AMapLocationClientOption locationOption = new AMapLocationClientOption();
        locationOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.Battery_Saving);
        locationOption.setOnceLocation(true);
        locationClient.setLocationOption(locationOption);
        locationClient.stopLocation();
        locationClient.startLocation();
    }

    void getWeatherData(final Context context, String district, double longitude, double latitude) {

        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl("https://api.caiyunapp.com/v2/TwsDo9aQUYewFhV8/")
                .addConverterFactory(GsonConverterFactory.create())
                .build();
        ApiService apiService = retrofit.create(ApiService.class);
        Call<WeatherBean> call = apiService.weather(longitude, latitude);
        call.enqueue(new Callback<WeatherBean>() {
            @Override
            public void onResponse(@NonNull Call<WeatherBean> call, @NonNull Response<WeatherBean> response) {
                WeatherBean weatherBean = response.body();
                updateAppWidget(UPDATE_SUCCESS, context, district, weatherBean);
            }

            @Override
            public void onFailure(@NonNull Call<WeatherBean> call, @NonNull Throwable t) {
                updateAppWidget(UPDATE_FAIL, context, district, null);
            }
        });
    }

    void updateAppWidget(int status, Context context, String district, WeatherBean weatherBean) {
        ComponentName componentName = new ComponentName(context, AppWidget.class);
        RemoteViews remoteViews = new RemoteViews(context.getPackageName(), R.layout.app_widget);

        // 打开APP首页的Intent
        Intent launchIntent = new Intent(context, MainActivity.class);
        PendingIntent launchPendingIntent = PendingIntent.getActivity(context, 0, launchIntent,
                PendingIntent.FLAG_CANCEL_CURRENT);

        // 刷新的Intent
        Intent updateIntent = new Intent(ACTION_UPDATE);
        updateIntent.setClass(context, AppWidget.class);
        PendingIntent updatePendingIntent = PendingIntent.getBroadcast(context, 0, updateIntent, PendingIntent.FLAG_CANCEL_CURRENT);

        if (status == NO_LOCATION) {
            remoteViews.setTextViewText(R.id.widget_district_tv, district);
            remoteViews.setTextViewText(R.id.widget_update_time_tv, context.getString(R.string.widget_unknown));
            remoteViews.setOnClickPendingIntent(R.id.widget_rl, launchPendingIntent);
            remoteViews.setOnClickPendingIntent(R.id.widget_update_fl, updatePendingIntent);

            RemoteViews animViewDefault = new RemoteViews(context.getPackageName(), R.layout.app_widget_anim_view_default);
            remoteViews.removeAllViews(R.id.widget_update_anim_fl);
            remoteViews.addView(R.id.widget_update_anim_fl, animViewDefault);
        } else if (status == UPDATING) {
            remoteViews.setTextViewText(R.id.widget_update_time_tv, context.getString(R.string.widget_updating));
            remoteViews.setOnClickPendingIntent(R.id.widget_rl, launchPendingIntent);

            RemoteViews animView = new RemoteViews(context.getPackageName(), R.layout.app_widget_anim_view);
            remoteViews.removeAllViews(R.id.widget_update_anim_fl);
            remoteViews.addView(R.id.widget_update_anim_fl, animView);
        } else if (status == UPDATE_SUCCESS) {
            showAppWidgetData(context, remoteViews, district, weatherBean);
            remoteViews.setOnClickPendingIntent(R.id.widget_rl, launchPendingIntent);
            remoteViews.setOnClickPendingIntent(R.id.widget_update_fl, updatePendingIntent);

            RemoteViews animViewDefault = new RemoteViews(context.getPackageName(), R.layout.app_widget_anim_view_default);
            remoteViews.removeAllViews(R.id.widget_update_anim_fl);
            remoteViews.addView(R.id.widget_update_anim_fl, animViewDefault);
        } else if (status == UPDATE_FAIL) {
            remoteViews.setTextViewText(R.id.widget_update_time_tv, context.getString(R.string.widget_update_failed));
            remoteViews.setOnClickPendingIntent(R.id.widget_rl, launchPendingIntent);
            remoteViews.setOnClickPendingIntent(R.id.widget_update_fl, updatePendingIntent);

            RemoteViews animViewDefault = new RemoteViews(context.getPackageName(), R.layout.app_widget_anim_view_default);
            remoteViews.removeAllViews(R.id.widget_update_anim_fl);
            remoteViews.addView(R.id.widget_update_anim_fl, animViewDefault);
        }
        AppWidgetManager.getInstance(context).updateAppWidget(componentName, remoteViews);
    }

    private void showAppWidgetData(Context context, RemoteViews remoteViews, String district, WeatherBean weatherBean) {
        Realtime realtime = weatherBean.result.realtime;
        Daily daily = weatherBean.result.daily;

        remoteViews.setTextViewText(R.id.widget_district_tv, district);
        remoteViews.setTextViewText(R.id.widget_weather_tv, TranslationUtils.getWeatherDesc(realtime.skycon, realtime.precipitation.local.intensity));
        remoteViews.setTextViewText(R.id.widget_temperature_tv, toInt(realtime.temperature) + "°");

        String updateDate = DateUtils.getFormatDate(weatherBean.server_time * 1000, DateUtils.HHmm);
        remoteViews.setTextViewText(R.id.widget_update_time_tv, context.getString(R.string.widget_update_time, updateDate));

        remoteViews.setTextViewText(R.id.widget_max_min_tv, toInt(daily.temperature.get(0).max)
                + " / " + toInt(daily.temperature.get(0).min) + "°");

        // 明天预报
        Skycon skycon1 = daily.skycon.get(1);
        Temperature temperature1 = daily.temperature.get(1);
        remoteViews.setTextViewText(R.id.widget_forecast_day_1_tv, context.getString(R.string.widget_tomorrow));
        remoteViews.setImageViewResource(R.id.widget_forecast_icon_1_iv, ImageUtils.getWeatherIcon(skycon1.value));
        remoteViews.setTextViewText(R.id.widget_forecast_temperature_1_iv, toInt(temperature1.max)
                + " / " + toInt(temperature1.min) + "°");

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
            remoteViews.setTextViewText(R.id.widget_forecast_temperature_2_iv, toInt(temperature2.max)
                    + " / " + toInt(temperature2.min) + "°");
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
            remoteViews.setTextViewText(R.id.widget_forecast_temperature_3_iv, toInt(temperature3.max)
                    + " / " + toInt(temperature3.min) + "°");
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

    int toInt(double value) {
        return (int) (value + 0.5);
    }
}

//        SharedPreferences sharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
//        String locationDistrictBean = sharedPreferences.getString("flutter.location_district", "");