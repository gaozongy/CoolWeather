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

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import www.gl.com.coolweather.MainActivity;
import www.gl.com.coolweather.R;
import www.gl.com.coolweather.bean.WeatherBean;
import www.gl.com.coolweather.net.ApiService;


public abstract class BaseAppWidget extends AppWidgetProvider {

    /**
     * 更新
     */
    public static final String ACTION_UPDATE = "action_update";
    /**
     * 无定位
     */
    public final int NO_LOCATION = 0x01;
    /**
     * 正在更新
     */
    public final int UPDATING = 0x02;
    /**
     * 更新成功
     */
    public final int UPDATE_SUCCESS = 0x03;
    /**
     * 更新失败
     */
    public final int UPDATE_FAILED = 0x04;

    @Override
    public void onReceive(final Context context, Intent intent) {
        super.onReceive(context, intent);

        String action = intent.getAction();
        // 手动刷新
        if (ACTION_UPDATE.equals(action)) {
            getLocationData(context);
        }
    }

    @Override
    public void onUpdate(final Context context, final AppWidgetManager appWidgetManager, final int[] appWidgetIds) {
        // 自动刷新
        getLocationData(context);
    }

    /**
     * 获取定位数据
     */
    private void getLocationData(Context context) {
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            updateAppWidget(context, NO_LOCATION, context.getString(R.string.widget_no_location_permission), null);
            return;
        }

        // 显示正在更新
        updateAppWidget(context, UPDATING, "", null);

        AMapLocationListener mLocationListener = aMapLocation -> {
            if (aMapLocation.getErrorCode() == 0) {
                String district = aMapLocation.getDistrict();
                double longitude = aMapLocation.getLongitude();
                double latitude = aMapLocation.getLatitude();
                getWeatherData(context, district, longitude, latitude);
            } else {
                updateAppWidget(context, NO_LOCATION, context.getString(R.string.widget_location_failed), null);
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

    /**
     * 获取天气数据
     */
    private void getWeatherData(final Context context, String district, double longitude, double latitude) {

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
                updateAppWidget(context, UPDATE_SUCCESS, district, weatherBean);
            }

            @Override
            public void onFailure(@NonNull Call<WeatherBean> call, @NonNull Throwable t) {
                updateAppWidget(context, UPDATE_FAILED, district, null);
            }
        });
    }

    /**
     * 根据状态更新天气小部件
     *
     * @param status      更新状态
     * @param context     上下文
     * @param district    定位数据
     * @param weatherBean 天气数据
     */
    private void updateAppWidget(Context context, int status, String district, WeatherBean weatherBean) {
        ComponentName componentName = new ComponentName(context, this.getClass());
        RemoteViews remoteViews = new RemoteViews(context.getPackageName(), layoutId());

        if (status == NO_LOCATION) {
            // 无定位
            noLocation(context, remoteViews, district, weatherBean);
        } else if (status == UPDATING) {
            // 正在更新
            updating(context, remoteViews, district, weatherBean);
        } else if (status == UPDATE_SUCCESS) {
            // 更新成功
            updateSuccess(context, remoteViews, district, weatherBean);
        } else if (status == UPDATE_FAILED) {
            // 正在失败
            updateFail(context, remoteViews, district, weatherBean);
        }

        AppWidgetManager.getInstance(context).updateAppWidget(componentName, remoteViews);
    }

    /**
     * 获取 RemoteViews 布局 id
     */
    abstract protected int layoutId();

    abstract protected void noLocation(Context context, RemoteViews remoteViews, String district, WeatherBean weatherBean);

    abstract protected void updating(Context context, RemoteViews remoteViews, String district, WeatherBean weatherBean);

    abstract protected void updateSuccess(Context context, RemoteViews remoteViews, String district, WeatherBean weatherBean);

    abstract protected void updateFail(Context context, RemoteViews remoteViews, String district, WeatherBean weatherBean);

    /**
     * 创建跳转首界面 PendingIntent
     */
    protected PendingIntent createLaunchPendingIntent(Context context) {
        Intent launchIntent = new Intent(context, MainActivity.class);
        return PendingIntent.getActivity(context, 0, launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT);
    }

    /**
     * 创建更新数据 PendingIntent
     */
    protected PendingIntent createUpdatePendingIntent(Context context) {
        Intent updateIntent = new Intent(ACTION_UPDATE);
        updateIntent.setClass(context, this.getClass());
        return PendingIntent.getBroadcast(context, 0, updateIntent, PendingIntent.FLAG_UPDATE_CURRENT);
    }
}
