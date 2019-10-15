package www.gl.com.coolweather.widget;


import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.RemoteViews;

import www.gl.com.coolweather.R;

public class AppWidget extends AppWidgetProvider {

    private static final String TAG = "AppWidget";

    public static final String START_ACT_ACTION = "com.example.widget";

    public static final String RECEIVER_ACTION_STATUS = "com.widget.STATUS_CHANGED";
    public static final int OPEN_ACT_CODE = 111;

    private static RemoteViews remoteViews;

    /**
     * 接收到任意广播时触发
     *
     * @param context
     * @param intent
     */
    @Override
    public void onReceive(Context context, Intent intent) {
        super.onReceive(context, intent);
        String action = intent.getAction();
        Log.e(TAG, "onReceive: " + action);
        if (RECEIVER_ACTION_STATUS.equals(action)) {

            if (null == remoteViews) {
                remoteViews = new RemoteViews(context.getPackageName(), R.layout.app_widget);
            }

            if (WidgetReceiver.status == 0) {
                remoteViews.setTextViewText(R.id.widget_title, "播放中");
                remoteViews.setImageViewResource(R.id.widget_pause, R.mipmap.ic_launcher);
            } else {
                remoteViews.setTextViewText(R.id.widget_title, "电台桌面插件");
                remoteViews.setImageViewResource(R.id.widget_pause, R.mipmap.ic_launcher);
            }
            ComponentName componentName = new ComponentName(context, AppWidget.class);
            AppWidgetManager.getInstance(context).updateAppWidget(componentName, remoteViews);
        }
    }

    /**
     * 当 widget 更新时触发
     * 用户首次添加时也会被调用
     * 如果定义了widget的configure属性，首次添加时不会被调用
     *
     * @param context
     * @param appWidgetManager
     * @param appWidgetIds
     */
    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
    }

    /**
     * 当 widget 首次添加或者大小被改变时触发
     *
     * @param context
     * @param appWidgetManager
     * @param appWidgetId
     * @param newOptions
     */
    @Override
    public void onAppWidgetOptionsChanged(Context context, AppWidgetManager appWidgetManager, int appWidgetId, Bundle newOptions) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions);
        Log.e(TAG, "onAppWidgetOptionsChanged: ");
    }

    /**
     * 当第1个 widget 的实例被创建时触发。也就是说,如果用户对同一个 widget 增加了两次（两个实例）,
     * 那么onEnabled()只会在第一次增加widget时触发
     *
     * @param context
     */
    @Override
    public void onEnabled(Context context) {
    }

    /**
     * 当最后1个 widget 的实例被删除时触发
     *
     * @param context
     */
    @Override
    public void onDisabled(Context context) {
    }

    /**
     * 当 widget 被删除时
     *
     * @param context
     * @param appWidgetIds
     */
    @Override
    public void onDeleted(Context context, int[] appWidgetIds) {
        super.onDeleted(context, appWidgetIds);
    }

    /*******************************************************************************************************************/

    /**
     * 更新
     *
     * @param context
     * @param appWidgetManager
     * @param appWidgetId
     */
    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {

        Log.e(TAG, "updateAppWidget: ");
        remoteViews = new RemoteViews(context.getPackageName(), R.layout.app_widget);
        remoteViews.setTextViewText(R.id.widget_title, "电台桌面插件");
        openAct(context);
        radioCtrl(context);
        appWidgetManager.updateAppWidget(appWidgetId, remoteViews);

    }


    /**
     * 点击标题 打开activity
     * 通过PendingIntent 添加一个跳转activity
     *
     * @param context
     */
    private static void openAct(Context context) {
        Intent intent = new Intent();
        intent.setAction(START_ACT_ACTION);
        PendingIntent pi = PendingIntent.getActivity(context, OPEN_ACT_CODE, intent, PendingIntent.FLAG_CANCEL_CURRENT);
        remoteViews.setOnClickPendingIntent(R.id.widget_title, pi);
    }

    /**
     * 控制 播放（模拟）
     * 通过PendingIntent 添加一个Broadcast
     *
     * @param context
     */
    private static void radioCtrl(Context context) {

        Intent intent = new Intent(WidgetReceiver.ACTION_WIDGET_CTRL);
        intent.putExtra(WidgetReceiver.INTENT_EXTRAS, WidgetReceiver.ACTION_WIDGET_PAUSE);//暂停 播放
        remoteViews.setOnClickPendingIntent(R.id.widget_pause, PendingIntent.getBroadcast(context, 11, intent, PendingIntent.FLAG_CANCEL_CURRENT));
        intent.putExtra(WidgetReceiver.INTENT_EXTRAS, WidgetReceiver.ACTION_WIDGET_NEXT);//下一首
        remoteViews.setOnClickPendingIntent(R.id.widget_next, PendingIntent.getBroadcast(context, 12, intent, PendingIntent.FLAG_CANCEL_CURRENT));
        intent.putExtra(WidgetReceiver.INTENT_EXTRAS, WidgetReceiver.ACTION_WIDGET_LAST);//上一首
        remoteViews.setOnClickPendingIntent(R.id.widget_last, PendingIntent.getBroadcast(context, 13, intent, PendingIntent.FLAG_CANCEL_CURRENT));
    }

}
