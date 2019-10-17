package www.gl.com.coolweather.widget;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.widget.RemoteViews;

import java.util.Calendar;

import www.gl.com.coolweather.MainActivity;
import www.gl.com.coolweather.R;

public class AppWidget extends AppWidgetProvider {

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
    }

    void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
        RemoteViews remoteViews = new RemoteViews(context.getPackageName(), R.layout.app_widget);
        remoteViews.setTextViewText(R.id.widget_district_tv, "南京");
        remoteViews.setTextViewText(R.id.widget_weather_tv, "晴");
        remoteViews.setTextViewText(R.id.widget_temperature_tv, "16°");
        remoteViews.setTextViewText(R.id.widget_max_min_tv, "19 / 13°");

        Calendar calendars = Calendar.getInstance();
        String hour = String.valueOf(calendars.get(Calendar.HOUR));
        String min = String.valueOf(calendars.get(Calendar.MINUTE));
        String second = String.valueOf(calendars.get(Calendar.SECOND));
        remoteViews.setTextViewText(R.id.widget_update_time_tv, hour + ":" + min + " 更新");

        remoteViews.setTextViewText(R.id.widget_forecast_day_1_tv, "明天");
        remoteViews.setImageViewResource(R.id.widget_forecast_icon_1_iv, R.mipmap.ic_launcher);
        remoteViews.setTextViewText(R.id.widget_forecast_temperature_1_iv, "22 / 14 °");

        remoteViews.setTextViewText(R.id.widget_forecast_day_2_tv, "周六");
        remoteViews.setImageViewResource(R.id.widget_forecast_icon_2_iv, R.mipmap.ic_launcher);
        remoteViews.setTextViewText(R.id.widget_forecast_temperature_2_iv, "22 / 14 °");

        remoteViews.setTextViewText(R.id.widget_forecast_day_3_tv, "周日");
        remoteViews.setImageViewResource(R.id.widget_forecast_icon_3_iv, R.mipmap.ic_launcher);
        remoteViews.setTextViewText(R.id.widget_forecast_temperature_3_iv, "22 / 14 °");

        Intent fullIntent = new Intent(context, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, fullIntent, PendingIntent.FLAG_CANCEL_CURRENT);
        remoteViews.setOnClickPendingIntent(R.id.widget_rl, pendingIntent);

        appWidgetManager.updateAppWidget(appWidgetId, remoteViews);
    }
}
