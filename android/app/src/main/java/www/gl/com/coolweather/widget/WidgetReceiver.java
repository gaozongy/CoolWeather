package www.gl.com.coolweather.widget;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class WidgetReceiver extends BroadcastReceiver {

    private static final String TAG = "WidgetReceiver";

    public static final String INTENT_EXTRAS = "Widget_Reciver";
    public static final String ACTION_WIDGET_CTRL = "com.example.widget.CTRL";

    public static final int ACTION_WIDGET_PAUSE = 0;
    public static final int ACTION_WIDGET_LAST = 1;
    public static final int ACTION_WIDGET_NEXT = 2;

    public static int status = 1;//0_播放 1_暂停

    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();

        Log.e(TAG, "onReceive: " + action);

        if (action.equals(ACTION_WIDGET_CTRL)) {
            int e = intent.getIntExtra(INTENT_EXTRAS, 0);
            Log.e(TAG, "onReceive: " + e);
            switch (e) {
                case ACTION_WIDGET_LAST:
                    Log.e(TAG, "onReceive: 播放上一首");
                    break;
                case ACTION_WIDGET_NEXT:
                    Log.e(TAG, "onReceive: 播放下一首");
                    break;
                case ACTION_WIDGET_PAUSE:
                    Log.e(TAG, "onReceive: 暂停/开始 播放");
                    status = status == 0 ? 1 : 0;
                    context.sendBroadcast(new Intent(AppWidget.RECEIVER_ACTION_STATUS));
                    break;
            }

        }

    }
}