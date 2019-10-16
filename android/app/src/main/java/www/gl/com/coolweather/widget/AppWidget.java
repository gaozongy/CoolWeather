package www.gl.com.coolweather.widget;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.widget.RemoteViews;

import java.util.Calendar;

import www.gl.com.coolweather.MainActivity;
import www.gl.com.coolweather.R;

public class AppWidget extends AppWidgetProvider {

    private static RemoteViews remoteViews;

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        for (int appWidgetId : appWidgetIds) {
            initAppWidget(context);
            appWidgetManager.updateAppWidget(appWidgetId, remoteViews);
        }
    }

    void initAppWidget(Context context) {
        if (remoteViews == null) {
            remoteViews = new RemoteViews(context.getPackageName(), R.layout.app_widget);
        }

        remoteViews.setTextViewText(R.id.widget_title, "Cool天气");

        Calendar calendars = Calendar.getInstance();
        String hour = String.valueOf(calendars.get(Calendar.HOUR));
        String min = String.valueOf(calendars.get(Calendar.MINUTE));
        String second = String.valueOf(calendars.get(Calendar.SECOND));
        remoteViews.setTextViewText(R.id.widget_time, hour + ":" + min + ":" + second);

        Intent fullIntent = new Intent(context, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, fullIntent, PendingIntent.FLAG_CANCEL_CURRENT);
        remoteViews.setOnClickPendingIntent(R.id.widget_title, pendingIntent);
    }

    @Override
    public void onAppWidgetOptionsChanged(Context context, AppWidgetManager appWidgetManager, int appWidgetId, Bundle newOptions) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions);
    }

    @Override
    public void onEnabled(Context context) {
    }

    @Override
    public void onDisabled(Context context) {
    }

    @Override
    public void onDeleted(Context context, int[] appWidgetIds) {
        super.onDeleted(context, appWidgetIds);
    }
}
